local awful_screen = require("awful.screen")
local beautiful = require("beautiful")
local wibox = require("wibox")

local helpers = require("helpers")
local calendar = require("ui.calendar-box.calendar")

local container_height = dpi(280)
local upcoming_events = nil

if beautiful.gcalendar_command then
    upcoming_events = require("ui.calendar-box.upcoming-events")
    container_height = dpi(440)
end

local container = wibox {
    type = "dock",
    screen = awful_screen.focused(),
    width = dpi(320),
    height = container_height,
    ontop = true,
    visible = false,
    shape = helpers.rrect(beautiful.border_radius)
}

container:setup{
    {
        calendar,
        upcoming_events,
        spacing = dpi(4),
        layout = wibox.layout.fixed.vertical
    },
    bg = beautiful.black,
    border_width = dpi(2),
    border_color = beautiful.focus,
    shape = helpers.rrect(beautiful.notif_center_radius),
    widget = wibox.container.background
}

return container
