local spawn = require("awful.spawn")
local gears_string = require("gears.string")

local function get_volume()
    spawn.easy_async(
        "pamixer --get-mute --get-volume", function(stdout)
            local muted, volume = table.unpack(gears_string.split(stdout, " "))
            awesome.emit_signal("signal::volume", tonumber(volume), muted == "true")
        end
    )
end

-- Volume Control
local function volume_control(type, value)
    local cmd
    if type == "increase" then
        cmd = "pamixer -i " .. tostring(value)
    elseif type == "decrease" then
        cmd = "pamixer -d " .. tostring(value)
    elseif type == "mute" then
        cmd = "pamixer -t"
    else
        cmd = "pamixer --set-volume " .. tostring(value)
    end

    spawn.easy_async(cmd, get_volume)
end

-- Brightness control
local function get_brightness()
    spawn.easy_async_with_shell(
        "brightnessctl i | grep -o '[0-9]*%'", function(stdout)
            local value = tonumber(stdout:match("(%d+)"))
            awesome.emit_signal("brightness::value", value)
        end
    )
end

local function brightness_control(type, value)
    local cmd
    if type == "increase" then
        cmd = "brightnessctl set 5%+ -q"
    elseif type == "decrease" then
        cmd = "brightnessctl set 5%- -q"
    else
        cmd = "brightnessctl set -q " .. tostring(value) .. "%"
    end

    spawn.easy_async(cmd, get_brightness)
end

-- Mic toggle
local function get_mic_mute()
    spawn.easy_async(
        "pamixer --default-source --get-mute", function(stdout)
            awesome.emit_signal("microphone::mute", stdout:match("true"))
        end
    )
end

local function mic_toggle(type, value)
    spawn.easy_async("pactl set-source-mute @DEFAULT_SOURCE@ toggle", get_mic_mute)
end

return {
    volume_control = volume_control,
    brightness_control = brightness_control,
    mic_toggle = mic_toggle
}
