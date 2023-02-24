# tabac #

import
  xam,
  text, preferences, c

from strutils import split,startsWith,endsWith,allCharsInSet,Whitespace
use sequtils,filterIt

type
  InputLine* = tuple
    original: TextLine
    partsAmount: int
    firstPart: string
    lastPart: string
    isComment: bool
    isDirective: bool
    isEmpty: bool
    indentation: int
    opensBlock: bool
    closesBlock: bool
    closingSemicolon: bool
  InputLines* = seq[InputLine]

proc getLeftWhitespace*(text: string, spacesPerTab: int): int {.inline.} =
  for c in text:
    if c == CHARS_SPACE:
      result += 1
    elif c == CHARS_TAB:
      result += spacesPerTab
    else:
      break

template detectDirectiveLine(firstPart: string): bool =
  firstPart.startsWith(STRINGS_NUMERAL)

template detectCommentLine(firstPart, lastPart: string): bool =
  firstPart.startsWith(C_LANGUAGE.LINE_COMMENT) or (
    firstPart.startsWith(C_LANGUAGE.MULTILINE_COMMENT_OPEN) and
    lastPart.endsWith(C_LANGUAGE.MULTILINE_COMMENT_CLOSE)
  )

proc makeInputLine(line: TextLine, indentation: int): InputLine =
  result.original = line
  result.isEmpty = line.raw.allCharsInSet(Whitespace)
  let parts = line.raw.split().filterIt(it != STRINGS_EMPTY)
  result.partsAmount = len(parts)
  result.firstPart = if result.partsAmount > 0: parts[0] else: STRINGS_EMPTY
  result.lastPart = if result.partsAmount > 0: parts[^1] else: STRINGS_EMPTY
  result.isDirective = result.partsAmount > 0 and detectDirectiveLine(result.firstPart)
  result.isComment = detectCommentLine(result.firstPart, result.lastPart)
  result.indentation = indentation

proc loadInputLines*(lines: TextLines, preferences: TabacPreferences): InputLines =
  for line in lines:
    result.add(makeInputLine(line, getLeftWhitespace(line.raw, preferences.SpacesPerTab)))

