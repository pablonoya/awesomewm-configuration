local beautiful = require("beautiful")
local wibox = require("wibox")

local variables = require("configuration.variables")
local border_popup = require("ui.widgets.border-popup")
local calendar = require("ui.info-docks.calendar-box.calendar")

local container_height = dpi(280)
local upcoming_events = nil

if variables.gcalendar_command then
    upcoming_events = require("ui.info-docks.calendar-box.upcoming_events")
    container_height = dpi(404)
end

local calendar_popup = border_popup {
    widget = wibox.widget {
        calendar,
        {
            forced_height = dpi(1),
            color = beautiful.focus,
            widget = wibox.widget.separator
        },
        upcoming_events,
        spacing = dpi(4),
        forced_width = beautiful.notif_center_width,
        forced_height = container_height,
        layout = wibox.layout.fixed.vertical
    }
}

calendar_popup:connect_signal(
    "property::visible", function(self)
        if self.visible then
        end
    end
)

return calendar_popup
