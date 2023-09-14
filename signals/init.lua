local beautiful = require("beautiful")

require("signals.battery-signals")
require("signals.redshift")
require("signals.wifi-signals")
require("signals.bluetooth-signals")
require("signals.volume-signals")

if beautiful.dominantcolors_path then
    require("signals.media-dominantcolors")
end
