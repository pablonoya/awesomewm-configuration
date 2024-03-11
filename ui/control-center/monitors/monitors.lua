local beautiful = require("beautiful")
local wibox = require("wibox")

local ram_meter = require("ui.control-center.monitors.ram_meter")

local cpu_usage = require("ui.control-center.monitors.cpu_usage")
local gpu_usage = require("ui.control-center.monitors.gpu_usage")

local cpu_temperature = require("ui.control-center.monitors.cpu_temperature")
local gpu_temperature = require("ui.control-center.monitors.gpu_temperature")

local controls_container = require("ui.control-center.widgets.controls-container")

local function container_title(title)
    return wibox.widget {
        text = title,
        font = beautiful.font_name .. "Bold 11",
        halign = "center",
        widget = wibox.widget.textbox
    }
end

local monitors = wibox.widget {
    controls_container {
        widget = ram_meter
    },
    controls_container {
        widget = wibox.widget {
            container_title "Usage %",
            cpu_usage,
            gpu_usage,

            spacing = dpi(8),
            layout = wibox.layout.fixed.vertical
        }
    },
    controls_container {
        widget = wibox.widget {
            container_title "Temperature °C",
            cpu_temperature,
            gpu_temperature,

            spacing = dpi(8),
            layout = wibox.layout.fixed.vertical
        }
    },
    layout = wibox.layout.fixed.vertical,
    spacing = dpi(12),
    visible = false
}

awesome.connect_signal(
    "control_center::monitor_mode", function(monitor_mode)
        monitors.visible = monitor_mode
    end
)

return monitors
