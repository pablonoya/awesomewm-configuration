local wibox = require("wibox")

local user_info = require("ui.control-center.top-controls.user-info")
local control_center_switch = require("ui.control-center.top-controls.control-center-switch")
local end_session = require("ui.control-center.top-controls.end-session")

return wibox.widget {
    {
        user_info,
        nil,
        {
            control_center_switch,
            end_session,
            spacing = dpi(8),
            layout = wibox.layout.fixed.horizontal
        },
        layout = wibox.layout.align.horizontal,
        forced_height = dpi(40)
    },
    widget = wibox.container.margin
}
