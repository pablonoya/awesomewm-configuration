local wibox_layout = require("wibox.layout")
local wibox_widget = require("wibox.widget")

local cpu_meter = require("ui.control-center.monitors.cpu-meter")
local ram_meter = require("ui.control-center.monitors.ram-meter")
local temperature_meter = require("ui.control-center.monitors.temperature-meter")
local controls_container = require("ui.control-center.widgets.controls-container")

local monitor_control_row_progressbars = wibox_widget {
    controls_container {
        widget = cpu_meter
    },
    controls_container {
        widget = ram_meter
    },
    controls_container {
        widget = temperature_meter
    },
    layout = wibox_layout.fixed.vertical,
    spacing = dpi(12)
}

return wibox_widget {
    monitor_control_row_progressbars,
    visible = false,
    layout = wibox_layout.fixed.vertical
}
