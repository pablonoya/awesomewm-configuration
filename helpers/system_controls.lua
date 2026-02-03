local spawn = require("awful.spawn")
local gears_string = require("gears.string")
local asusctl_signals = require("signals.asusctl_signals")

local _controls = {}

local function get_volume()
    spawn.easy_async(
        "pamixer --get-mute --get-volume", function(stdout)
            local muted, volume = table.unpack(gears_string.split(stdout, " "))
            awesome.emit_signal("signal::volume", tonumber(volume), muted == "true")
        end
    )
end

-- Volume Control
function _controls.volume_control(type, value)
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

function _controls.brightness_control(type, value)
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
function _controls.emit_mic_muted()
    spawn.easy_async(
        "pamixer --default-source --get-mute", function(stdout)
            awesome.emit_signal("microphone::muted", stdout:match("true"))
        end
    )
end

function _controls.mic_toggle(type, value)
    spawn.easy_async("pactl set-source-mute @DEFAULT_SOURCE@ toggle", _controls.emit_mic_muted)
end

function _controls.next_asusctl_profile()
    spawn.easy_async("asusctl profile next", asusctl_signals.emit_profile)
end

function _controls.previous_asusctl_profile()
    spawn.easy_async(
        "sh -c 'asusctl profile next ; asusctl profile next'", asusctl_signals.emit_profile
    )
end

-- Power Control commands
function _controls.poweroff()
    spawn("systemctl poweroff")
end

function _controls.reboot()
    spawn("systemctl reboot")
end

function _controls.suspend()
    spawn("systemctl suspend")
end

return _controls
