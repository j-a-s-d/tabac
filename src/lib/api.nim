# tabac #

import
  xam,
  c, text, input, transform, validate, preprocess, preferences

const
  TABAC_EXTENSION = ".tabac"
  TABAH_EXTENSION = ".tabah"

proc tabac(origin: string, text: TextLines, preferences: TabacPreferences, onForbidenContentHandler: OnForbidenTabacContent, code: var string): bool =
  let lines: InputLines = transformInputLines(loadInputLines(text, preferences))
  if validateInputLines(origin, lines, onForbidenContentHandler):
    code = preprocessInputLines(lines, preferences)
    return true
  return false

proc tabacText(origin: string, lines: StringSeq, preferences: TabacPreferences, onForbidenContentHandler: OnForbidenTabacContent, code: var string): bool =
  tabac(origin, loadTextLines(lines & STRINGS_EOL), preferences, onForbidenContentHandler, code)

proc tabacFile(filename: string, preferences: TabacPreferences, onForbidenContentHandler: OnForbidenTabacContent, code: var string): bool =
  var lines = newStringSeq()
  for line in lines(filename):
    lines.add(line)
  tabacText(filename, lines, preferences, onForbidenContentHandler, code)

export
  preferences,
  validate.OnForbidenTabacContent,
  c.C_EXTENSION,
  c.H_EXTENSION,
  TABAC_EXTENSION,
  TABAH_EXTENSION,
  tabacText,
  tabacFile

