# tabac #

import
  xam,
  test_engine/test_suites

use strutils,split

proc getPreferencesFor(name: string): TabacPreferences =
  (
    MessagesLanguageCode: "en",
    SpacesPerTab: if name == "tabs_8": 8 else: 4,
    StripCommentLines: if name == "comments_strip": true else: false,
    BlankLinesRemoval: if name == "blank_keep": BLANK_LINES_REMOVAL_KEEP
      elif name == "blank_remove": BLANK_LINES_REMOVAL_REMOVE
      else: BLANK_LINES_REMOVAL_SHRINK
  )

let runTestCase: TestRunner = proc (test: TestFiles): int =
  TestConsole.launch(test.name)
  let contents = loadTestContents(test)
  var index = 0
  var amount = len(contents.controlContent)
  let stop = (msg: string) => (TestConsole.fail(msg); halt())
  let output = process(test.inputFile, contents.inputContent, stop, getPreferencesFor(extractFilenameWithoutExtension(test.inputFile)))
  for line in output.split(STRINGS_EOL):
    if index == amount:
      return TestConsole.error("consumed all content at " & test.controlFile)
    let controlLine = contents.controlContent[index]
    inc(index)
    if line != controlLine:
      writeFile(test.inputFile & ".output", output)
      return TestConsole.error(lined(
        "  mismatch at " & test.controlFile & ":" & $index,
        "    expected: " & controlLine,
        "    received: " & line
      ))
  if amount > index:
    return TestConsole.error("unconsumed content at " & test.controlFile)
  TestConsole.ok()

testSuite((
  directoryName: "configuration_cases",
  casesRunner: runTestCase
))

