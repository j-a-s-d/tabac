# tabac #

import
  xam

reexport test_console, test_console

type
  TestFiles* = tuple
    name: string
    inputFile: string
    controlFile: string
  TestContents* = tuple
    inputContent: StringSeq
    controlContent: StringSeq
  TestRunner* = proc (test: TestFiles): int

proc loadTextFile*(filename: string): StringSeq =
  for line in lines(filename):
    result.add(line)

proc loadTestContents*(testFiles: TestFiles): TestContents =
  if not filesExist(testFiles.inputFile):
    TestConsole.fail("could not load " & testFiles.inputFile)
    halt()
  if not filesExist(testFiles.controlFile):
    TestConsole.fail("could not load " & testFiles.controlFile)
    halt()
  result.inputContent = loadTextFile(testFiles.inputFile)
  result.controlContent = loadTextFile(testFiles.controlFile)

