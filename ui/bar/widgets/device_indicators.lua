local awful_tooltip = require("awful.tooltip")
local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")

local system_controls = require("helpers.system_controls")
local helpers = require("helpers")

local text_icon = require("ui.widgets.text-icon")

local mic_icon = text_icon {
    text = "\u{e029}",
    size = 16
}

helpers.add_action(mic_icon, system_controls.mic_toggle)

awesome.connect_signal(
    "microphone::muted", function(muted)
        mic_icon.text = muted and "\u{e02b}" or "\u{e029}"
    end
)
local mic_indicator = wibox.widget {
    mic_icon,
    visible = false,
    margins = dpi(2),
    widget = wibox.container.margin
}

local mic_device_name = awful_tooltip {
    objects = {mic_indicator},
    text = "Microphone"
}

awesome.connect_signal(
    "microphone::device", function(name)
        mic_device_name.text = name:gsub("\n", "")
    end
)

local cam_icon = wibox.widget {
    text_icon {
        text = "\u{f7a6}",
        size = 16
    },
    visible = false,
    margins = dpi(2),
    widget = wibox.container.margin
}

local device_indicators = wibox.widget {
    {
        {
            {
                {
                    cam_icon,
                    mic_indicator,
                    layout = wibox.layout.fixed.horizontal
                },
                left = dpi(2),
                right = dpi(2),
                widget = wibox.container.margin
            },
            fg = beautiful.black,
            bg = beautiful.green,
            forced_height = dpi(28),
            shape = gears.shape.rounded_bar,
            widget = wibox.container.background
        },
        widget = wibox.container.place
    },
    visible = false,
    left = dpi(4),
    right = dpi(4),
    widget = wibox.container.margin
}

awesome.connect_signal(
    "microphone::state", function(state)
        mic_indicator.visible = state
        device_indicators.visible = state or cam_icon.visible
    end
)

awesome.connect_signal(
    "webcam::active", function(active)
        cam_icon.visible = active
        device_indicators.visible = active or mic_icon.visible
    end
)

return device_indicators
