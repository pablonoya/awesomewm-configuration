local variables = require("configuration.variables")

require(... .. ".battery_signals")
require(... .. ".wifi_signals")
require(... .. ".bluetooth_signals")
require(... .. ".volume_signals")
require(... .. ".redshift")
require(... .. ".asusctl_signals")

if variables.dominantcolors_path then
    require(... .. ".media_dominantcolors")
end

if variables.weather_api_key then
    require(... .. ".weather_signals")
end
