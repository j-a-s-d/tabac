# tabac #

import
  xam,
  input, text, c

use strutils,isSpaceAscii
use strutils,toLowerAscii
use strutils,startsWith
use strutils,contains

type
  OnForbidenTabacContent* = TripleArgsVoidProc[string, int, string]

func grantByLastChar(chr: char): bool {.inline.} =
  chr in C_VALID_LAST_CHARS

func grantBySingleKeyword(keyword: string): bool {.inline.} =
  toLowerAscii(keyword) in C_VALID_SINGLE_KEYWORDS

func grantByStartsWith(text: string): bool {.inline.} =
  for keyword in C_VALID_LINE_STARTS:
    if text.startsWith(keyword):
      return true
  return false

template detectInvalidCode(il: InputLine): bool =
  not (
    (il.partsAmount == 1 and grantBySingleKeyword(il.firstPart)) or
    (len(il.lastPart) > 0 and grantByLastChar(il.lastPart[^1])) or
    grantByStartsWith(il.firstPart)
  )

template detectTrailingComment(rawLine: string): bool =
  rawLine.contains(C_LANGUAGE.LINE_COMMENT)

template detectMultilineComment(rawLine: string): bool =
  rawLine.contains(C_LANGUAGE.MULTILINE_COMMENT_OPEN)

type
  BlockInfo = tuple
    openNumber: int
    openIndentation: int
    closeIndentation: int
const DEFAULT_BLOCK_INFO: BlockInfo = (openNumber: -1, openIndentation: -1, closeIndentation: -1)

proc validateInputLines*(origin: string, lines: InputLines, onForbidenContentHandler: OnForbidenTabacContent): bool =
  var level: seq[BlockInfo] = @[];
  var last: BlockInfo = DEFAULT_BLOCK_INFO
  for il in lines:
    func err(code: string): bool =
      onForbidenContentHandler(origin, il.original.number, code)
      return false
    let isInsideBlock = len(level) > 0
    if not il.isComment and not il.isEmpty and not il.isDirective:
      if detectTrailingComment(il.original.raw):
        return err("TABAC_ERRORS.FORBIDDEN_TRAILING_COMMENT")
      elif detectMultilineComment(il.original.raw):
        return err("TABAC_ERRORS.FORBIDDEN_MULTILINE_COMMENT")
      elif detectInvalidCode(il):
        return err("TABAC_ERRORS.FORBIDDEN_CODE_LINE")
      if il.opensBlock:
        last = DEFAULT_BLOCK_INFO
        level.push(( openNumber: il.original.number, openIndentation: il.indentation, closeIndentation: -1 ))
      elif il.closesBlock and isInsideBlock:
        last = level.pop()
        last.closeIndentation = il.indentation
    elif (last.closeIndentation > 0 and il.indentation >= last.closeIndentation) or
      (il.isDirective and isInsideBlock and level.peek(DEFAULT_BLOCK_INFO).openIndentation > il.indentation):
      return err("TABAC_ERRORS.FORBIDDEN_NONCODE_LINE")
  return true

