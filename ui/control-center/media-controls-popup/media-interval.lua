local beautiful = require("beautiful")
local wibox = require("wibox")

local playerctl = require("signals.playerctl")

local function secs_to_min(secs)
    local mins = math.floor(secs / 60)
    local remain_secs = secs % 60

    return string.format("%.0f", mins) .. ":" .. string.format("%02d", remain_secs)
end

local interval = wibox.widget {
    text = "-/-",
    font = beautiful.font_name .. "11",
    valign = "center",
    halign = "right",
    widget = wibox.widget.textbox
}

playerctl:connect_signal(
    "position", function(_, interval_sec, length_sec)
        interval:set_markup_silently(secs_to_min(interval_sec) .. " / " .. secs_to_min(length_sec))
    end
)

return interval
