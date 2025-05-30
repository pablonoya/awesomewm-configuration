local beautiful = require("beautiful")
local wibox = require("wibox")

local helpers = require("helpers")

local border_popup = require("ui.widgets.border-popup")

local info_and_buttons = require("ui.control-center.top-controls.container")
local controls = require("ui.control-center.controls.controls")
local monitors = require("ui.control-center.monitors.monitors")
local media_controls_popup = require("ui.control-center.media-controls-popup")

local body_container = wibox.widget {
    {
        {
            info_and_buttons,
            {
                controls,
                monitors,
                layout = wibox.layout.stack
            },
            layout = wibox.layout.fixed.vertical,
            spacing = dpi(12)
        },
        margins = dpi(8),
        widget = wibox.container.margin
    },
    bg = beautiful.wibar_bg,
    forced_width = dpi(beautiful.control_center_width),
    shape = helpers.rrect(beautiful.border_radius),
    widget = wibox.container.background
}

local control_center = border_popup {
    widget = body_container
}

local last_height = control_center.height
control_center:connect_signal(
    "property::height", function(self)
        if last_height ~= self.height then
            media_controls_popup.y = media_controls_popup.y + (self.height - last_height)
            last_height = self.height
        end
    end
)

control_center:connect_signal(
    "property::visible", function(self)
        awesome.emit_signal("control_center::visible", self.visible)
    end
)

return control_center
