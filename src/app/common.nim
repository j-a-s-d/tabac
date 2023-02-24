# tabac #

import
  rodster, xam

const
  APP_URL*: string = "http://github.com/j-a-s-d/tabac"
  APP_KEYS*: tuple = (INPUT: "input", OUTPUT: "output")

let produceSignature* = (nfo: RodsterAppInformation) => spaced(
  nfo.getTitle(), STRINGS_LOWERCASE_V & $nfo.getVersion()
)

let inform* = proc (label, msg: string) = echo(spaced(bracketize(label), msg))

template chill*(msg: string) = inform(ansiGreen("tabac:OK!"), msg)

template panic*(msg: string) = inform(ansiRed("tabac:ERR"), msg)

