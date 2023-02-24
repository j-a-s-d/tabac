# tabac #

import
  rodster, xam,
  common, messages, settings

use strutils,split

const
  README: string = staticRead("../../README.txt")

proc onInitialize*(app: RodsterApplication) =
  let nfo = app.getInformation()
  let args = nfo.getArguments()
  let ac = len(args)
  if ac == 0:
    var help = README.split(STRINGS_EOL)
    help[0] = produceSignature(nfo)
    help[1] = parenthesize(CompileDate)
    echo(lined(help))
    halt()
  else:
    let kvm = app.getKvm()
    kvm[APP_KEYS.INPUT] = args[0]
    kvm[APP_KEYS.OUTPUT] = if ac > 1: args[1] else: STRINGS_EMPTY
    let sts = app.getSettings()
    if sts.loadFromFile(CONFIG_FILE):
      readLoadedSettings(sts)
    let i18n = app.getI18n()
    loadMessages(i18n)
    i18n.setCurrentLocale(Preferences.MessagesLanguageCode)

