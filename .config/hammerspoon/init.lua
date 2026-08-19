require("hs.ipc")

hs.dockIcon(false)
hs.autoLaunch(true)

require("window")
require("ime")
-- require("space")

ConfigWatcher = hs.pathwatcher.new(hs.fs.pathToAbsolute(hs.configdir), hs.reload):start()
hs.alert.show("Hammerspoon: config loaded")
