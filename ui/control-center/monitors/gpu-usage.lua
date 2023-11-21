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
        widget = wibox_widget.imagebox
    },
    margins = dpi(2),
    widget = wibox_container.margin
}

local function format_info(stdout)
    stdout = tonumber(stdout) or 0
    return stdout, string.format("%.1f %%", stdout)
end

local gpu_usage = monitor_progressbar {
    name = "dGPU",
    icon_widget = meter_icon,
    info = "0.0 %",
    slider_color = {
        type = "linear",
        from = {0},
        to = {240},
        stops = {{0, beautiful.cyan}, {0.3, beautiful.green}}
    },
    bg_color = beautiful.green .. "60",
    watch_command = [[ bash -c "nvidia-smi -q -d UTILIZATION | grep Gpu | awk '{print \$3}'"]],
    format_info = format_info,
    interval = 2
}

return gpu_usage
