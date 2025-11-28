local spawn = require("awful.spawn")
local beautiful = require("beautiful")
local wibox_widget = require("wibox.widget")

local system_controls = require("helpers.system_controls")

local clickable_container = require("ui.widgets.clickable-container")
local slider = require("ui.widgets.slider")
local text_icon = require("ui.widgets.text-icon")

local value_text = require("ui.control-center.widgets.value-text")
local setting_slider = require("ui.control-center.widgets.setting-slider")

local mic_icon = text_icon {
    text = "\u{e029}"
}

local mic_value = value_text {
    text = "0%"
}

local mic_device_name = wibox_widget {
    text = "-",
    font = beautiful.font_name .. " Semibold 10",
    valign = "center",
    forced_height = dpi(12),
    widget = wibox_widget.textbox
}

local mic_slider = slider {
    bar_bg_color = beautiful.green .. "60",
    bar_color = beautiful.green,
    handle_color = beautiful.green
}

mic_slider:connect_signal(
    "property::value", function(_, new_value)
        spawn("pactl set-source-volume @DEFAULT_SOURCE@ " .. new_value .. "%")
        mic_value.text = new_value .. "%"
    end
)

local mic_device = clickable_container {
    widget = mic_device_name,
    fg = beautiful.green,
    bg_focused = beautiful.green .. "32",
    margins = {
        left = dpi(6),
        right = dpi(6)
    },
    action = function()
        spawn("pavucontrol -t 4")
    end
}

awesome.connect_signal(
    "microphone::device", function(name)
        mic_device_name.text = name
    end
)

awesome.connect_signal(
    "microphone::muted", function(muted)
        if muted then
            mic_icon.text = "\u{e02b}"
            mic_slider.bar_active_color = beautiful.green .. "60"
            mic_slider.handle_color = beautiful.focus
        else
            mic_icon.text = "\u{e029}"
            mic_slider.bar_active_color = beautiful.green
            mic_slider.handle_color = beautiful.green
        end
    end
)

-- check_volume
spawn.easy_async_with_shell(
    "pamixer --default-source --get-volume", function(stdout)
        mic_slider:set_value(tonumber(stdout))
    end
)

return setting_slider {
    name = "Microphone",
    device_widget = mic_device,
    icon = mic_icon,
    action_button = system_controls.mic_toggle,
    slider = mic_slider,
    action_up = function()
        mic_slider:set_value(mic_slider:get_value() + 5)
    end,
    action_down = function()
        mic_slider:set_value(mic_slider:get_value() - 5)
    end,
    value_text = mic_value
}
