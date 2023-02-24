# tabac #

import
  xam

const
  BLANK_LINES_REMOVAL_KEEP*: string = "keep"
  BLANK_LINES_REMOVAL_REMOVE*: string = "remove"
  BLANK_LINES_REMOVAL_SHRINK*: string = "shrink"
  BLANK_LINES_REMOVAL_VALUES* = [
    BLANK_LINES_REMOVAL_KEEP,
    BLANK_LINES_REMOVAL_REMOVE,
    BLANK_LINES_REMOVAL_SHRINK
  ]
  MESSAGES_LANGUAGE_CODE_VALUES* = [
    LANGUAGE_CODES.EN,
    LANGUAGE_CODES.ES,
    LANGUAGE_CODES.PT
  ]
  PREFERENCES_KEYS*: tuple = (
    MESSAGES_LANGUAGE_CODE: "messages-language-code",
    SPACES_PER_TAB: "spaces-per-tab",
    STRIP_COMMENT_LINES: "strip-comment-lines",
    BLANK_LINES_REMOVAL: "blank-lines-removal"
  )
  PREFERENCES_DEFAULTS*: tuple = (
    MESSAGES_LANGUAGE_CODE: LANGUAGE_CODES.EN,
    SPACES_PER_TAB: 4,
    STRIP_COMMENT_LINES: false,
    BLANK_LINES_REMOVAL: BLANK_LINES_REMOVAL_SHRINK
  )

type
  TabacPreferences* = tuple
    MessagesLanguageCode: string
    SpacesPerTab: int
    StripCommentLines: bool
    BlankLinesRemoval: string

