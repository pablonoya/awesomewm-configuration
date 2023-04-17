local spawn = require("awful.spawn")
local watch = require("awful.widget.watch")

spawn.easy_async_with_shell(
    "nmcli radio wifi", function(stdout)
        awesome.emit_signal("wifi::state", stdout:match("enabled"))
    end
)

local function emit_ssid_signal(_, stdout)
    if stdout ~= "" then
        awesome.emit_signal("wifi::ssid", stdout:gsub("\n", ""))
    end
end

awesome.connect_signal(
    "wifi::state", function(state)
        if state then
            watch("iwgetid -r", 5, emit_ssid_signal)
        end
    end
)
