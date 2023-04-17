local awful_screen = require("awful.screen")
local beautiful = require("beautiful")
local wibox = require("wibox")

local helpers = require("helpers")
local calendar = require("ui.calendar-box.calendar")

local container = wibox {
    type = "dock",
    screen = awful_screen.focused(),
    width = dpi(320),
    height = dpi(280),
    ontop = true,
    visible = false,
    shape = helpers.rrect(beautiful.border_radius)
}

container:setup{
    calendar,
    bg = beautiful.black,
    border_width = dpi(2),
    border_color = beautiful.focus,
    shape = helpers.rrect(beautiful.notif_center_radius),
    widget = wibox.container.background
}

return container
