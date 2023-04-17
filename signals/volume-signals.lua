local spawn = require("awful.spawn")
local watch = require("awful.widget.watch")

watch(
    [[ sh -c 'pactl -f json list sinks | jq -r ".[] |
        select(.name==\"$(pactl get-default-sink)\").properties.\"device.description\""'
    ]], 3, function(_, stdout)
        awesome.emit_signal("volume::device", stdout)
    end
)

watch(
    [[ sh -c 'pactl -f json list sources | jq -r ".[] |
    select(.name==\"$(pactl get-default-source)\").properties.\"device.description\""'
    ]], 5, function(_, stdout)
        awesome.emit_signal("microphone::device", stdout)
    end
)
