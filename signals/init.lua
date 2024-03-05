local beautiful = require("beautiful")

require(... .. ".battery_signals")
require(... .. ".wifi_signals")
require(... .. ".bluetooth_signals")
require(... .. ".volume-signals")
require(... .. ".redshift")
require(... .. ".asusctl_signals")

if beautiful.dominantcolors_path then
    require(... .. ".media-dominantcolors")
end

if beautiful.weather_api_key then
    require(... .. ".weather-signals")
end
