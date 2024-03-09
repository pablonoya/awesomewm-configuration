local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")

local system_controls = require("helpers.system_controls")
local text_icon = require("ui.widgets.text-icon")
local helpers = require("helpers")

local icon = text_icon {
    text = "\u{e029}",
    size = 16
}

local mic_indicator = wibox.widget {
    {
        {
            icon,
            margins = dpi(2),
            widget = wibox.container.margin
        },
        fg = beautiful.black,
        bg = beautiful.green,
        shape = gears.shape.circle,
        widget = wibox.container.background
    },
    visible = false,
    left = dpi(4),
    right = dpi(4),
    widget = wibox.container.margin
}

helpers.add_action(mic_indicator, system_controls.mic_toggle)

local device_name = awful.tooltip {
    objects = {mic_indicator},
    text = "Microphone"
}

awesome.connect_signal(
    "microphone::device", function(name)
        device_name.text = name:gsub("\n", "")
    end
)

awesome.connect_signal(
    "microphone::state", function(state)
        mic_indicator.visible = state
    end
)

awful.spawn.easy_async(
    "pamixer --default-source --get-mute", function(stdout)
        icon.text = stdout:match("true") and "\u{e02b}" or "\u{e029}"
    end
)

awesome.connect_signal(
    "microphone::mute", function(muted)
        icon.text = muted and "\u{e02b}" or "\u{e029}"
    end
)

return mic_indicator
