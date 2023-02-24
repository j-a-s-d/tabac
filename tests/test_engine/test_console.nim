# tabac #

import
  xam

const
  TEST_OK*: int = 0
  TEST_ERROR*: int = 1

let TestConsole*: tuple = (
  fail: (msg: string) => echo(spaced(ansiRed("FATAL"), msg)),
  launch: (msg: string) => stdout.write(spaced(ansiBrightBlue("RUNNING"), msg, "...")),
  ok: proc (msg: string = STRINGS_EMPTY): int = (
    if hasContent(msg): stdout.write(msg);
    echo(ansiGreen(" ✓"));
    return TEST_OK;
  ),
  error: proc (msg: string): int = (
    echo(lined(ansiBrightRed(" x"), ansiBrightRed("ERROR ") & msg));
    return TEST_ERROR;
  ),
  report: (errors: int) => echo(if errors == 0: ansiBrightGreen("OK") else: ansiRed("ERRORS " & $errors))
)

