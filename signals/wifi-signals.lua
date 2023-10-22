local spawn = require("awful.spawn")
local gtimer = require("gears.timer")

spawn.easy_async_with_shell(
    "nmcli radio wifi", function(stdout)
        awesome.emit_signal("wifi::state", stdout:match("enabled"))
    end
)

local current_ssid
local function emit_ssid_signal()
    spawn.easy_async_with_shell(
        "iwgetid -r", function(ssid)
            if ssid == "" or ssid == current_ssid then
                return
            end

            awesome.emit_signal("wifi::ssid", ssid:gsub("\n", ""))
            current_ssid = ssid
        end
    )
end

local timer = gtimer {
    timeout = 2,
    call_now = true,
    callback = emit_ssid_signal
}

awesome.connect_signal(
    "wifi::state", function(state)
        if state then
            timer:start()
        else
            current_ssid = nil
            timer:stop()
        end
    end
)
