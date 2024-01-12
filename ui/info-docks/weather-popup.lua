local border_popup = require('ui.widgets.border-popup')
local weather = require("ui.info-docks.calendar-box.widgets.weather")

local weather_popup = border_popup {
    widget = weather
}

return weather_popup
