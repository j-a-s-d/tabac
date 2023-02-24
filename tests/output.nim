# tabac #

import
  xam,
  test_engine/test_suites

use strutils,split

const OUTPUT_EXTENSION = ".output"

let runTestCase: TestRunner = proc (test: TestFiles): int =
  TestConsole.launch(test.name)
  let contents = loadTestContents(test)
  var index = 0
  var amount = len(contents.controlContent)
  let stop = (msg: string) => (TestConsole.fail(msg); halt())
  let output = process(test.inputFile, contents.inputContent, stop)
  for line in output.split(STRINGS_EOL):
    if index == amount:
      return TestConsole.error("consumed all content at " & test.controlFile)
    let controlLine = contents.controlContent[index]
    inc(index)
    if line != controlLine:
      writeFile(test.inputFile & OUTPUT_EXTENSION, output)
      return TestConsole.error(lined(
        "  mismatch at " & test.controlFile & ":" & $index,
        "    expected: " & controlLine,
        "    received: " & line
      ))
  if amount > index:
    return TestConsole.error("unconsumed content at " & test.controlFile)
  TestConsole.ok()

testSuite((
  directoryName: "output_cases",
  casesRunner: runTestCase
))

