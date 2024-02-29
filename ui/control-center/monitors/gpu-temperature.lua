local beautiful = require("beautiful")
local gcolor = require("gears.color")
local wibox_container = require("wibox.container")
local wibox_widget = require("wibox.widget")

local icons = require("ui.icons")

local monitor_progressbar = require("ui.widgets.monitor-progressbar")

local meter_icon = wibox_widget {
    {
        image = gcolor.recolor_image(icons.gpu, beautiful.xforeground),
        forced_width = dpi(16),
        forced_height = dpi(18),
        scaling_quality = "best",
        widget = wibox_widget.imagebox
    },
    margins = dpi(2),
    widget = wibox_container.margin
}
local function format_info(stdout)
    stdout = tonumber(stdout) or 0
    return stdout, string.format("%.1f °", stdout)
end

local gpu_temperature = monitor_progressbar {
    name = "dGPU",
    icon_widget = meter_icon,
    info = "0 °",
    min_value = 20,
    max_value = 100,
    slider_color = {
        type = "linear",
        from = {0},
        to = {255},
        stops = {{0.4, beautiful.green}, {0.75, beautiful.yellow}, {0.9, beautiful.red}}
    },
    bg_color = beautiful.yellow .. "60",
    watch_command = [[
        bash -c "nvidia-smi -q -d TEMPERATURE | grep 'GPU Current Temp' | awk '{print \$5}'"
    ]],
    format_info = format_info,
    interval = 2
}

return gpu_temperature
