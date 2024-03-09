local spawn = require("awful.spawn")

local last_volume_device
local last_mic_device

local function emit_volume_device()
    spawn.easy_async_with_shell(
        [[
            pactl -f json list sinks | jq -r ".[] |
            select(.name==\"$(pactl get-default-sink)\").properties.\"device.description\""
        ]], function(stdout)
            if last_volume_device ~= stdout then
                last_volume_device = stdout
                awesome.emit_signal("volume::device", stdout)
            end
        end
    )
end

local function emit_mic_device()
    spawn.easy_async_with_shell(
        [[
            pactl -f json list sources | jq -r ".[] |
            select(.name==\"$(pactl get-default-source)\").properties.\"device.description\""
        ]], function(stdout)
            if last_mic_device ~= stdout then
                last_mic_device = stdout
                awesome.emit_signal("microphone::device", stdout)
            end
        end
    )
end

local function emit_mic_muted()
    spawn.easy_async_with_shell(
        [[
            pamixer --list-sources |
            grep -v '"Monitor of' |
            grep -o '"Running" "[^"]*"' |
            cut -d '"' -f4
        ]], function(stdout)
            awesome.emit_signal("microphone::state", stdout ~= "")
        end
    )
end

-- Check initial states
emit_volume_device()
emit_mic_device()
emit_mic_muted()

-- Kill previous instances of pactl
spawn.with_shell("killall pactl")

spawn.with_line_callback(
    [[ sh -c "pactl subscribe 2> /dev/null | grep --line-buffered \"Event 'change' on sink #\"" ]],
        {
            stdout = function(line)
                emit_volume_device()
            end
        }
)

spawn.with_line_callback(
    [[ sh -c "pactl subscribe 2> /dev/null | grep --line-buffered \"Event 'change' on source #\"" ]],
        {
            stdout = function(line)
                emit_mic_device()
                emit_mic_muted()
            end
        }
)
