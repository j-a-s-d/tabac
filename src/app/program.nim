# tabac #

import
  rodster, xam,
  common, messages, settings, ../lib/api

use os,changeFileExt

proc determineInputFile(kvm: RodsterAppKvm): string =
  result = kvm[APP_KEYS.INPUT]
  if not filesExist(result):
    let inputTabac = result & TABAC_EXTENSION
    if not filesExist(inputTabac):
      return STRINGS_EMPTY
    else:
      return inputTabac

proc determineOutputFile(kvm: RodsterAppKvm, inputFile: string): string =
  if hasText(kvm[APP_KEYS.OUTPUT]):
    kvm[APP_KEYS.OUTPUT]
  else:
    changeFileExt(inputFile, C_EXTENSION)

proc programRun*(app: RodsterApplication) =
  let i18n = app.getI18n()
  let kvm = app.getKvm()
  let inputFile = determineInputFile(kvm)
  if not hasText(inputFile):
    panic(i18n.getText(APP_ERROR.INEXISTENT, [kvm[APP_KEYS.INPUT]]))
  else:
    var code = STRINGS_EMPTY
    let forbid = proc (origin: string, line: int, message: string) =
      panic(i18n.getText(message, [origin, $line]))
    if tabacFile(inputFile, Preferences, forbid, code):
      let outputFile = determineOutputFile(kvm, inputFile)
      let banner = i18n.getText(APP_INFO.BANNER, [produceSignature(app.getInformation()), APP_URL])
      if writeToFile(outputFile, lined(banner, code)):
        chill(i18n.getText(APP_ERROR.EMITTED, [outputFile, $len(code)]))
        quit()
      else:
        panic(i18n.getText(APP_ERROR.UNWRITABLE, [outputFile]))
  halt()

