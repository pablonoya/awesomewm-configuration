local beautiful = require("beautiful")
local wibox_container = require("wibox.container")
local wibox_widget = require("wibox.widget")

local monitor_progressbar = require("ui.control-center.monitors.monitor_progressbar")
local text_icon = require("ui.widgets.text-icon")

local meter_icon = text_icon {
    text = "\u{e322}"
}

local total_prev = 0
local idle_prev = 0

local function format_info(stdout)
    local user, nice, system, idle, iowait, irq, softirq, steal, guest, guest_nice = stdout:match(
        "(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s"
    )

    local total = user + nice + system + idle + iowait + irq + softirq + steal

    local diff_idle = idle - idle_prev
    local diff_total = total - total_prev
    local diff_usage = (1000 * (diff_total - diff_idle) / diff_total + 5) / 10

    total_prev = total
    idle_prev = idle
    return diff_usage, string.format("%.2f %%", diff_usage)
end

local cpu_usage = monitor_progressbar {
    name = "CPU",
    icon_widget = meter_icon,
    info = "0.00 %",
    slider_color = {
        type = "linear",
        from = {0},
        to = {240},
        stops = {{0, beautiful.blue}, {0.1, beautiful.blue}, {1, beautiful.magenta}}
    },
    bg_color = beautiful.blue .. "60",
    watch_command = [[ bash -c "cat /proc/stat | grep '^cpu '"]],
    format_info = format_info,
    interval = 1
}

return cpu_usage
