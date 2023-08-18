local awful_popup = require("awful.popup")
local beautiful = require("beautiful")
local wibox_container = require("wibox.container")
local wibox_layout = require("wibox.layout")

local helpers = require("helpers")

local info_and_buttons = require("ui.control-center.top-controls.container")
local controls = require("ui.control-center.controls.container")
local monitors = require("ui.control-center.monitors.container")
local media_controls_popup = require("ui.control-center.media-controls-popup")

local body_container = {
    {
        {
            info_and_buttons,
            {
                controls,
                monitors,
                layout = wibox_layout.stack
            },
            layout = wibox_layout.fixed.vertical,
            spacing = dpi(12)
        },
        margins = dpi(16),
        widget = wibox_container.margin
    },
    bg = beautiful.wibar_bg,
    shape = helpers.rrect(beautiful.border_radius),
    widget = wibox_container.background
}

local control_center = awful_popup {
    type = "dock",
    maximum_width = dpi(beautiful.control_center_width),
    border_width = dpi(2),
    border_color = beautiful.focus,
    ontop = true,
    visible = false,
    shape = helpers.rrect(beautiful.border_radius),
    widget = body_container
}

local last_height = control_center.height
awesome.connect_signal(
    "control_center::monitor_mode", function(monitor_mode)
        if monitor_mode then
            controls.visible = false
            monitors.visible = true
        else
            controls.visible = true
            monitors.visible = false
        end
    end
)

control_center:connect_signal(
    "property::height", function(self)
        if last_height ~= self.height then
            media_controls_popup.y = media_controls_popup.y + (self.height - last_height)
            last_height = self.height
        end
    end
)

return control_center
