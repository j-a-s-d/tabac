# tabac #

import
  rodster, xam,
  ../lib/api

const
  CONFIG_FILE*: string = "tabac.cfg"

var
  Preferences*: TabacPreferences = (
    MessagesLanguageCode: LANGUAGE_CODES.EN,
    SpacesPerTab: 4,
    StripCommentLines: false,
    BlankLinesRemoval: BLANK_LINES_REMOVAL_SHRINK
  )

use strutils,toLowerAscii

proc setupSettingsModel*(mdl: JsonModel) =
  mdl.registerMandatoryString(PREFERENCES_KEYS.MESSAGES_LANGUAGE_CODE)
  mdl.registerMandatoryInteger(PREFERENCES_KEYS.SPACES_PER_TAB)
  mdl.registerMandatoryBoolean(PREFERENCES_KEYS.STRIP_COMMENT_LINES)
  mdl.registerMandatoryString(PREFERENCES_KEYS.BLANK_LINES_REMOVAL)

proc readLoadedSettings*(sts: RodsterAppSettings) =
  Preferences.SpacesPerTab = sts.getAsInteger(
    PREFERENCES_KEYS.SPACES_PER_TAB,
    PREFERENCES_DEFAULTS.SPACES_PER_TAB
  )
  Preferences.StripCommentLines = sts.getAsBoolean(
    PREFERENCES_KEYS.STRIP_COMMENT_LINES,
    PREFERENCES_DEFAULTS.STRIP_COMMENT_LINES
  )
  let blr = toLowerAscii(sts.getAsString(
    PREFERENCES_KEYS.BLANK_LINES_REMOVAL,
    PREFERENCES_DEFAULTS.BLANK_LINES_REMOVAL
  ))
  Preferences.BlankLinesRemoval = if blr in BLANK_LINES_REMOVAL_VALUES:
    blr else: PREFERENCES_DEFAULTS.BLANK_LINES_REMOVAL
  let mlc = toLowerAscii(sts.getAsString(
    PREFERENCES_KEYS.MESSAGES_LANGUAGE_CODE,
    PREFERENCES_DEFAULTS.MESSAGES_LANGUAGE_CODE
  ))
  Preferences.MessagesLanguageCode = if mlc in MESSAGES_LANGUAGE_CODE_VALUES:
    mlc else: PREFERENCES_DEFAULTS.MESSAGES_LANGUAGE_CODE

