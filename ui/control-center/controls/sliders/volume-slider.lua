local spawn = require("awful.spawn")
local beautiful = require("beautiful")
local gears_string = require("gears.string")
local wibox = require("wibox")

local system_controls = require("helpers.system-controls")
local ui_helpers = require("helpers.ui-helpers")

local slider = require("ui.widgets.slider")
local text_icon = require("ui.widgets.text-icon")
local clickable_container = require("ui.widgets.clickable-container")

local value_text = require("ui.control-center.widgets.value-text")
local setting_slider = require("ui.control-center.widgets.setting-slider")

local volume_icon = text_icon {
    text = "\u{e04e}"
}

local vol_value = value_text {
    text = "0%"
}

local volume_device_name = wibox.widget {
    text = "",
    font = beautiful.font_name .. " Medium 10",
    valign = "center",
    align = "right",
    forced_height = dpi(12),
    widget = wibox.widget.textbox
}

local volume_device = clickable_container {
    widget = volume_device_name,
    bg = beautiful.xbackground,
    margins = {
        left = dpi(6),
        right = dpi(6)
    },
    action = function()
        spawn("pavucontrol -t 3")
    end
}

local volume_slider = slider {
    bar_bg_color = beautiful.accent .. '60',
    bar_color = beautiful.accent,
    handle_color = beautiful.accent
}

local function set_muted_style(muted)
    if muted then
        volume_icon.text = "\u{e04f}"
        volume_slider.bar_active_color = beautiful.accent .. '60'
        volume_slider.handle_color = beautiful.focus
    else
        volume_icon.text = ui_helpers.get_volume_icon(volume_slider:get_value())
        volume_slider.bar_active_color = beautiful.accent
        volume_slider.handle_color = beautiful.accent
    end
end

local function check_volume_and_mute()
    spawn.easy_async(
        "pamixer --get-mute --get-volume", function(stdout)
            local muted, volume = table.unpack(gears_string.split(stdout, " "))

            volume_slider:set_value(tonumber(volume))
            set_muted_style(muted == "true")
        end
    )
end

local function toggle_mute()
    system_controls.volume_control("mute")
end

awesome.connect_signal(
    "signal::volume", function(value, muted)
        volume_slider:set_value(tonumber(value))
        set_muted_style(muted)
    end
)

volume_slider:connect_signal(
    "property::value", function(_, new_value)
        volume_icon.text = ui_helpers.get_volume_icon(new_value)
        vol_value.text = new_value .. "%"
        spawn("pamixer --set-volume " .. tostring(new_value))
    end
)

awesome.connect_signal(
    "volume::device", function(name)
        volume_device_name.text = name
    end
)

check_volume_and_mute()

return setting_slider {
    name = "Volume",
    device_widget = volume_device,
    icon = volume_icon,
    action_button = toggle_mute,

    slider = volume_slider,
    action_up = function()
        volume_slider:set_value(volume_slider:get_value() + 5)
    end,
    action_down = function()
        volume_slider:set_value(volume_slider:get_value() - 5)
    end,
    value_text = vol_value
}
