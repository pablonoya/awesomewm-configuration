local beautiful = require("beautiful")

local playerctl = require("signals.playerctl")
local slider = require("ui.widgets.slider")

local progressbar = slider {
    bar_bg_color = beautiful.accent .. "70",
    bar_color = beautiful.accent,
    handle_width = dpi(12),
    handle_color = beautiful.accent,
    handle_border_width = 0
}

local previous_value = 0
local internal_update = false

progressbar:connect_signal(
    "property::value", function(_, new_value)
        if internal_update and new_value ~= previous_value then
            playerctl:set_position(new_value)
            previous_value = new_value
        end
    end
)

local last_length = 0
playerctl:connect_signal(
    "position", function(_, interval_sec, length_sec)
        if length_sec ~= last_length then
            progressbar.maximum = length_sec
            last_length = length_sec
        end

        internal_update = true
        previous_value = interval_sec
        progressbar.value = interval_sec
    end
)
awesome.connect_signal(
    "media::dominantcolors", function(colors)
        local fg_color = colors[2]

        progressbar.bar_color = fg_color .. "70"
        progressbar.bar_active_color = fg_color
        progressbar.handle_color = fg_color
    end
)

return progressbar
