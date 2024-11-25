local beautiful = require("beautiful")
local helpers = require("helpers")
local wibox = require("wibox")

local weather_popup = require("ui.info-docks.weather_popup")

return wibox.widget {
    weather_popup.widget,

    forced_width = dpi(256),
    border_width = dpi(2),
    border_color = beautiful.focus,
    bg = beautiful.xbackground,
    shape = helpers.rrect(beautiful.border_radius - 4),
    widget = wibox.container.background
}
