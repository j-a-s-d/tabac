# tabac #

import
  xam

reexport tabac_wrapper, tabac_wrapper
reexport test_cases, test_cases

use times,now
use times,format
use os,changeFileExt
use os,walkFiles
use os,DirSep

type
  TestSuite* = tuple
    directoryName: string
    casesRunner: TestRunner

proc scanForTests(directory: string): seq[TestFiles] =
  for path in walkFiles(directory & DirSep & STRINGS_ASTERISK & TABAC_EXTENSION):
    result.add((
      name: extractFilenameWithoutExtension(path),
      inputFile: path,
      controlFile: changeFileExt(path, C_EXTENSION)
    ))

template suiteStart(directory, timestamp: string) = echo(ansiYellow("--[ " & directory & " ] tests started at " & timestamp))

template suiteStop(directory, amount, seconds: string) = echo(ansiBrightYellow("--[ " & directory & " ] " & amount & " tests took " & seconds & "s"))

proc testSuite*(suite: TestSuite) =
  let tests = scanForTests(suite.directoryName)
  suiteStart(suite.directoryName, now().format(DATETIME_FORMAT_DDMMYYYY_HHMMSS))
  let chronometer = newChronometer()
  chronometer.start()
  var errors = 0
  for test in tests:
    errors += suite.casesRunner(test)
  chronometer.stop()
  suiteStop(suite.directoryName, $len(tests), $chronometer.measureSeconds())
  TestConsole.report(errors)

