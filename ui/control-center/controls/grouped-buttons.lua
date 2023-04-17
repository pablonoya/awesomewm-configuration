local wibox_widget = require("wibox.widget")
local wibox_layout = require("wibox.layout")

local bluetooth = require("ui.control-center.controls.toggle-buttons.bluetooth-toggle")
local night_light = require("ui.control-center.controls.toggle-buttons.night-light")
local silent_mode = require("ui.control-center.controls.toggle-buttons.silent-mode")
local wifi = require("ui.control-center.controls.toggle-buttons.wifi-toggle")

return wibox_widget {
    {
        wifi,
        bluetooth,
        nil,
        layout = wibox_layout.flex.horizontal,
        spacing = dpi(8)
    },
    {
        night_light,
        silent_mode,
        nil,
        layout = wibox_layout.flex.horizontal,
        spacing = dpi(8)
    },
    spacing = dpi(8),
    layout = wibox_layout.fixed.vertical
}
