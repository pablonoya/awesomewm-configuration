local spawn = require("awful.spawn")
local beautiful = require("beautiful")
local gshape = require("gears.shape")

local ui_helpers = require("helpers.ui-helpers")

local slider = require("ui.widgets.slider")
local text_icon = require("ui.widgets.text-icon")

local value_text = require("ui.control-center.widgets.value-text")
local setting_slider = require("ui.control-center.widgets.setting-slider")

local icon = text_icon {
    text = "\u{e1ad}"
}

local value_text = value_text {
    text = "0%"
}

local brightness_slider = slider {
    bar_bg_color = beautiful.moon .. '60',
    bar_color = beautiful.moon,
    handle_color = beautiful.yellow
}

brightness_slider:connect_signal(
    "property::value", function()
        local value = brightness_slider:get_value()

        spawn("brightnessctl s -q " .. value .. "%", false)
        value_text.text = value .. '%'
        icon.text = ui_helpers.get_brightness_icon(value)
    end
)

local function action_jump()
    local value = brightness_slider:get_value()
    local new_value = 0

    if value >= 0 and value < 25 then
        new_value = 25
    elseif value >= 25 and value < 50 then
        new_value = 50
    elseif value >= 50 and value < 75 then
        new_value = 75
    elseif value >= 75 and value < 100 then
        new_value = 100
    end

    icon.text = ui_helpers.get_brightness_icon(new_value)
    brightness_slider:set_value(new_value)
end

local bslider = setting_slider {
    name = "Brightness",
    icon = icon,
    action_button = action_jump,

    slider = brightness_slider,
    action_up = function()
        brightness_slider:set_value(brightness_slider:get_value() + 5)
    end,
    action_down = function()
        brightness_slider:set_value(brightness_slider:get_value() - 5)
    end,
    value_text = value_text
}

spawn.easy_async_with_shell(
    "brightnessctl i | grep -o '[0-9]*%'", function(stdout)
        local value = tonumber(stdout:match("(%d+)"))
        brightness_slider:set_value(value)
    end
)

awesome.connect_signal(
    "brightness::value", function(value)
        brightness_slider:set_value(tonumber(value))
    end
)

return bslider
