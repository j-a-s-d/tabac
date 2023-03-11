# tabac #

import
  xam,
  input, c

type
  LevelState = tuple
    lastWasEmptyOrDirective: bool
    currentIndentation: int

proc markBlockInstructions(il: var InputLine, state: var LevelState) =
  if not il.isDirective and not state.lastWasEmptyOrDirective:
    if il.indentation > state.currentIndentation:
      il.opensBlock = true
      state.currentIndentation = il.indentation
    elif il.indentation < state.currentIndentation:
      il.closesBlock = true
      state.currentIndentation = il.indentation
  state.lastWasEmptyOrDirective = il.isEmpty or il.isDirective

proc shiftBlockInstructions(result: var InputLines) =
  var state: LevelState = (false, 0)
  var lastCodeLine = -1
  let lastIndex = len(result) - 1
  for index in countup(1, lastIndex):
    let m = index - 1
    if not result[m].isComment and not result[m].isDirective and not result[m].isEmpty:
      lastCodeLine = m
    if lastCodeLine > -1:
      result[lastCodeLine].opensBlock |= result[index].opensBlock
      result[index].opensBlock = false
      let autoclose = result[lastCodeLine].opensBlock and
        result[lastCodeLine].indentation == result[index].indentation
      result[lastCodeLine].closesBlock |= result[index].closesBlock or autoclose
      result[index].closesBlock = false
    if state.lastWasEmptyOrDirective and state.currentIndentation > result[index].indentation:
      result[lastCodeLine].closesBlock = true
    state.currentIndentation = result[index].indentation
    state.lastWasEmptyOrDirective = result[index].isEmpty or result[index].isDirective

proc adjustBlockInstructions(il: var InputLine, state: var LevelState) =
  let lastChar = if len(il.lastPart) > 0: il.lastPart[^1] else: CHARS_SPACE
  if il.opensBlock:
    il.opensBlock = lastChar != CHARS_SEMICOLON
  else:
    let isSelfClosing = (il.firstPart in C_SELF_CLOSING_EMPTY_STRUCTURES and lastChar != CHARS_SEMICOLON)
    let isAfterParen = (
      il.partsAmount > 1 and lastChar == CHARS_PARENTHESES_CLOSE and not il.firstPart.contains(CHARS_PARENTHESES_OPEN)
    )
    if isSelfClosing or isAfterParen:
      il.opensBlock = true
      il.closesBlock = not (isAfterParen and il.firstPart == C_LANGUAGE.SWITCH_KEYWORD)
  il.closingSemicolon = il.opensBlock and (il.firstPart in C_CLOSING_SEMICOLON_STRUCTURES or lastChar == CHARS_EQUAL)

proc transformInputLines*(lines: InputLines): InputLines =
  result = lines
  if len(result) > 0:
    var state: LevelState = (false, 0)
    result.meach il:
      markBlockInstructions(il, state)
    shiftBlockInstructions(result)
    state = (false, 0)
    result.meach il:
      adjustBlockInstructions(il, state)

