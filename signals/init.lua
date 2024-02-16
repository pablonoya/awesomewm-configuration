local beautiful = require("beautiful")

require(... .. ".battery-signals")
require(... .. ".redshift")
require(... .. ".wifi-signals")
require(... .. ".bluetooth-signals")
require(... .. ".volume-signals")

if beautiful.dominantcolors_path then
    require(... .. ".media-dominantcolors")
end

if beautiful.weather_api_key then
    require(... .. ".weather-signals")
end
