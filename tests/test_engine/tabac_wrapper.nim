# tabac #

import
  xam

reexport ../../src/lib/api, api

var DefaultPreferences = (
  SpacesPerTab: 4,
  StripCommentLines: false,
  BlankLinesRemoval: BLANK_LINES_REMOVAL_SHRINK
)

proc forbid(origin: string, line: int, message: string) =
  echo(STRINGS_EOL & spaced(ansiRed("ERROR"), chevronize(origin & STRINGS_COLON & $line), message))

proc process*(inputFile: string, inputContent: StringSeq, onFailure: SingleArgVoidProc[string], preferences: TabacPreferences = DefaultPreferences): string =
  var generated = STRINGS_EMPTY
  if not tabacText(inputFile, inputContent, preferences, forbid, generated):
    onFailure("could not process " & inputFile)
  generated

