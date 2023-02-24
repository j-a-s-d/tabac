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
    closeIndentation: int
const RESET_BLOCK_INFO: BlockInfo = (openNumber: -1, closeIndentation: -1)

proc validateInputLines*(origin: string, lines: InputLines, onForbidenContentHandler: OnForbidenTabacContent): bool =
  var level: seq[BlockInfo] = @[];
  var last: BlockInfo = RESET_BLOCK_INFO
  for il in lines:
    let isCodeLine = not il.isComment and not il.isEmpty and not il.isDirective
    if isCodeLine:
      if detectTrailingComment(il.original.raw):
        onForbidenContentHandler(origin, il.original.number, "TABAC_ERRORS.FORBIDDEN_TRAILING_COMMENT")
        return false
      elif detectMultilineComment(il.original.raw):
        onForbidenContentHandler(origin, il.original.number, "TABAC_ERRORS.FORBIDDEN_MULTILINE_COMMENT")
        return false
      elif detectInvalidCode(il):
        onForbidenContentHandler(origin, il.original.number, "TABAC_ERRORS.FORBIDDEN_CODE_LINE")
        return false
      if il.opensBlock:
        last = RESET_BLOCK_INFO
        level.push(( openNumber: il.original.number, closeIndentation: -1 ))
      elif il.closesBlock and len(level) > 0:
        last = level.pop()
        last.closeIndentation = il.indentation
    elif last.closeIndentation > 0:
      if il.indentation >= last.closeIndentation:
        onForbidenContentHandler(origin, il.original.number, "TABAC_ERRORS.FORBIDDEN_NONCODE_LINE")
        return false
  return true

