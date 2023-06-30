local beautiful = require("beautiful")
local gcolor = require("gears.color")
local wibox_container = require("wibox.container")
local wibox_widget = require("wibox.widget")

local icons = require("icons")

local progressbar = require("ui.widgets.progressbar")

local meter_icon = wibox_widget {
    {
        image = gcolor.recolor_image(icons.ram, beautiful.xforeground),
        forced_width = dpi(16),
        forced_height = dpi(18),
        widget = wibox_widget.imagebox
    },
    margins = dpi(2),
    widget = wibox_container.margin
}

local function format_info(stdout)
    local total, used, free, shared, buff_cache, available, total_swap, used_swap, free_swap =
        stdout:match(
            "(%d+)%s*(%d+)%s*(%d+)%s*(%d+)%s*(%d+)%s*(%d+)%s*(%d+)%s*(%d+)%s*(%d+)"
        )
    local value = used / total * 100
    local info = string.format("%.2f / %.2f GB", used / 1048576, total / 1048576)
    return value, info
end

local ram_meter = progressbar {
    name = "RAM",
    icon_widget = meter_icon,
    info = "- / -",
    slider_color = {
        type = "linear",
        from = {0, 0},
        to = {180, 0},
        stops = {{0, beautiful.cyan}, {1, beautiful.blue}}
    },
    bg_color = beautiful.accent .. "60",
    watch_command = 'bash -c "free --kilo"',
    format_info = format_info,
    interval = 5
}

return ram_meter
