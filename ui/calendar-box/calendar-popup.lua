local beautiful = require("beautiful")
local wibox = require("wibox")

local border_popup = require('ui.widgets.border-popup')
local calendar = require("ui.calendar-box.calendar")

local container_height = dpi(280)
local upcoming_events = nil

if beautiful.gcalendar_command then
    upcoming_events = require("ui.calendar-box.upcoming-events")
    container_height = dpi(440)
end

return border_popup {
    widget = wibox.widget {
        calendar,
        upcoming_events,
        spacing = dpi(4),
        forced_width = dpi(320),
        forced_height = container_height,
        layout = wibox.layout.fixed.vertical
    }
}
