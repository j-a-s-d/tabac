# tabac #
#-----------------------------------------------------------#
# by Javier Santo Domingo @ http://github.com/j-a-s-d/tabac #

when defined(js):
  {.error: "This application needs to be compiled with a c/cpp-like backend".}

import
  rodster, xam,
  app / [setup, program, settings]

let app = newRodsterApplication("tabac", "1.0.0")
setupSettingsModel(app.getSettings().getModel())
app.setInitializationHandler(onInitialize)
app.setMainRoutine(programRun)
app.run()

