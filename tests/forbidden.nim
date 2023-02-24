# tabac #

import
  xam,
  test_engine/test_suites

let runTestCase: TestRunner = proc (test: TestFiles): int =
  TestConsole.launch(test.name)
  let contents = loadTestContents(test)
  var message = STRINGS_EMPTY
  let capture = proc (msg: string) = message = msg
  let output = process(test.inputFile, contents.inputContent, capture)
  if not hasContent(message):
    return TestConsole.error(lined(
      test.inputFile & " did not fail as it should",
      "emitted: " & output
    ))
  TestConsole.ok(spaced(ansiMagenta("INFO"), message))

testSuite((
  directoryName: "forbidden_cases",
  casesRunner: runTestCase
))

