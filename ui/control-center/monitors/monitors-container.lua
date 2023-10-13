local beautiful = require("beautiful")
local wibox_layout = require("wibox.layout")
local wibox_widget = require("wibox.widget")

local ram_meter = require("ui.control-center.monitors.ram-meter")

local cpu_usage = require("ui.control-center.monitors.cpu-usage")
local gpu_usage = require("ui.control-center.monitors.gpu-usage")

local cpu_temperature = require("ui.control-center.monitors.cpu-temperature")
local gpu_temperature = require("ui.control-center.monitors.gpu-temperature")

local controls_container = require("ui.control-center.widgets.controls-container")

local monitor_control_row_progressbars = wibox_widget {
    controls_container {
        widget = ram_meter
    },
    controls_container {
        widget = wibox_widget {
            wibox_widget {
                text = "Usage %",
                font = beautiful.font_name .. "Bold 11",
                align = "center",
                widget = wibox_widget.textbox
            },
            cpu_usage,
            gpu_usage,
            spacing = dpi(8),
            layout = wibox_layout.fixed.vertical
        }
    },
    controls_container {
        widget = wibox_widget {
            wibox_widget {
                text = "Temperature °C",
                font = beautiful.font_name .. "Bold 11",
                align = "center",
                widget = wibox_widget.textbox
            },
            cpu_temperature,
            gpu_temperature,
            spacing = dpi(8),
            layout = wibox_layout.fixed.vertical
        }
    },
    layout = wibox_layout.fixed.vertical,
    spacing = dpi(12)
}

return wibox_widget {
    monitor_control_row_progressbars,
    visible = false,
    layout = wibox_layout.fixed.vertical
}
