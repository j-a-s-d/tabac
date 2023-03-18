# tabac #

import
  rodster, xam,
  common, messages, settings, ../lib/api

use os,changeFileExt

func determineInputFile(kvm: RodsterAppKvm): string =
  result = kvm[APP_KEYS.INPUT]
  if not filesExist(result):
    let inputTabac = result & TABAC_EXTENSION
    let inputTabah = result & TABAH_EXTENSION
    result = if filesExist(inputTabac): inputTabac
      elif filesExist(inputTabah): inputTabah
      else: STRINGS_EMPTY

func determineOutputFile(kvm: RodsterAppKvm, inputFile: string): string =
  if hasText(kvm[APP_KEYS.OUTPUT]):
    kvm[APP_KEYS.OUTPUT]
  else:
    changeFileExt(inputFile, if checkFileExtension(inputFile, TABAH_EXTENSION): H_EXTENSION else: C_EXTENSION)

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
      quit(-2)
    if tabacFile(inputFile, Preferences, forbid, code):
      let outputFile = determineOutputFile(kvm, inputFile)
      let banner = i18n.getText(APP_INFO.BANNER, [produceSignature(app.getInformation()), APP_URL])
      if writeToFile(outputFile, lined(banner, code)):
        chill(i18n.getText(APP_ERROR.EMITTED, [outputFile, $len(code)]))
        quit(0)
      else:
        panic(i18n.getText(APP_ERROR.UNWRITABLE, [outputFile]))
  quit(-1)

