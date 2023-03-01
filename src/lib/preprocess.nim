# tabac #

import
  xam,
  input, preferences, blocks

use strutils,spaces

proc preprocessInputLines*(lines: InputLines, preferences: TabacPreferences): string =
  let blankLinesFriend = preferences.BlankLinesRemoval in [
    BLANKLINESREMOVAL_KEEP, BLANKLINESREMOVAL_SHRINK
  ];
  var state: BlocksState
  for line in lines:
    if line.isEmpty:
      case preferences.BlankLinesRemoval:
        of BLANKLINESREMOVAL_KEEP: discard
        of BLANKLINESREMOVAL_REMOVE:
          if line.closesBlock and len(state.parentBlocks) > 0:
            result &= doCloseBlock(state)
          state.lastLineWasEmpty = false
          continue
        else: # BLANKLINESREMOVAL_SHRINK
          if state.lastLineWasEmpty:
            continue
    state.currentClosingSemicolon = line.closingSemicolon
    if not line.isDirective:
      while state.lastBlockIndentation > line.indentation and len(state.parentBlocks) > 0:
        result &= doCloseBlock(state)
    if line.isComment and preferences.StripCommentLines:
      continue
    result &= (if hasContent(result): STRINGS_EOL else: STRINGS_EMPTY) &
      spaces(line.indentation) & stripLeft(line.original.raw)
    state.lastLineWasCommentOrDirective = line.isDirective or line.isComment
    if state.lastLineWasCommentOrDirective:
      state.lastLineWasEmpty = false
      continue
    state.currentLineNumber = line.original.number
    state.currentLineIndentation = line.indentation
    if line.opensBlock and line.closesBlock:
      result &= doOpenAndCloseBlock(state)
    elif line.closesBlock and len(state.parentBlocks) > 0:
      if state.lastLineWasEmpty and blankLinesFriend:
        result &= (if hasContent(result): STRINGS_EOL else: STRINGS_EMPTY)
      result &= doCloseBlock(state)
      continue
    elif line.opensBlock:
      result &= doOpenBlock(state)
    state.lastLineWasEmpty = line.isEmpty
    state.lastLineIndentation = line.indentation
  result &= doCloseAllBlocks(state)

