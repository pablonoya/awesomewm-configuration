local wibox_widget = require("wibox.widget")
local wibox_layout = require("wibox.layout")

local bluetooth = require("ui.control-center.controls.toggle_buttons.bluetooth_toggle")
local night_light = require("ui.control-center.controls.toggle_buttons.night_light")
local silent_mode = require("ui.control-center.controls.toggle_buttons.silent_mode")
local wifi = require("ui.control-center.controls.toggle_buttons.wifi_toggle")
local profile = require("ui.control-center.controls.toggle_buttons.asusctl_profile")

return wibox_widget {
    wifi,
    bluetooth,
    night_light,
    silent_mode,
    profile,

    spacing = dpi(8),
    horizontal_expand = true,
    forced_num_cols = 2,
    layout = wibox_layout.grid
}
