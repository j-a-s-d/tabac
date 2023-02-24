# tabac #

import
  xam

use strutils,spaces

type
  BlockInformation* = tuple
    indentation: int
    closingSemicolon: bool
  BlockInformations* = seq[BlockInformation]
  BlocksState* = tuple
    parentBlocks: BlockInformations
    lastBlockIndentation: int
    lastLineIndentation: int
    lastLineWasEmpty: bool
    lastLineWasCommentOrDirective: bool
    currentLineNumber: int
    currentLineIndentation: int
    currentClosingSemicolon: bool
  BlockOperation* = proc (state: var BlocksState): string

let doOpenBlock*: BlockOperation = proc (state: var BlocksState): string =
  result = (
    if state.lastLineWasCommentOrDirective:
      STRINGS_EOL & spaces(state.lastLineIndentation) else: STRINGS_SPACE
  ) & STRINGS_BRACES_OPEN
  state.parentBlocks.push((
    indentation: state.currentLineIndentation,
    closingSemicolon: state.currentClosingSemicolon
  ))
  state.lastBlockIndentation = state.currentLineIndentation

let doOpenAndCloseBlock*: BlockOperation = proc (state: var BlocksState): string =
  result = (
    if state.lastLineWasCommentOrDirective:
      STRINGS_EOL & spaces(state.lastLineIndentation) else: STRINGS_SPACE
  ) & STRINGS_BRACES_OPEN & STRINGS_BRACES_CLOSE & (
    if state.currentClosingSemicolon: STRINGS_SEMICOLON else: STRINGS_EMPTY
  )
  state.lastBlockIndentation = state.currentLineIndentation

let doCloseBlock*: BlockOperation = proc (state: var BlocksState): string =
  let info = state.parentBlocks.pop()
  state.lastBlockIndentation = info.indentation
  result = (if state.lastLineWasEmpty: STRINGS_EMPTY else: STRINGS_EOL) & (
    if state.lastBlockIndentation > 0: spaces(state.lastBlockIndentation) else: STRINGS_EMPTY
  ) & STRINGS_BRACES_CLOSE & (if info.closingSemicolon: STRINGS_SEMICOLON else: STRINGS_EMPTY)
  state.lastLineWasEmpty = false
  state.lastLineWasCommentOrDirective = false

let doCloseAllBlocks*: BlockOperation = proc (state: var BlocksState): string =
  while len(state.parentBlocks) > 0:
    result &= doCloseBlock(state)

