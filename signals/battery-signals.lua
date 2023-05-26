local spawn = require("awful.spawn")
local awful_widget = require("awful.widget")

local update_interval = 60

spawn.easy_async_with_shell(
    "sh -c 'out=\"$(find /sys/class/power_supply/BAT?/capacity)\" && (echo \"$out\" | head -1) || false' ",
    function(battery_file, _, __, exit_code)
        -- No battery file found
        if not (exit_code == 0) then
            return
        end
        -- Periodically get battery info
        awful_widget.watch(
            "cat " .. battery_file, update_interval, function(_, stdout)
                awesome.emit_signal("signal::battery", tonumber(stdout))
            end
        )
    end
)

spawn.easy_async_with_shell(
    "sh -c 'out=\"$(find /sys/class/power_supply/BAT?/status)\" && (echo \"$out\" | head -1) || false' ",
    function(battery_file, _, __, exit_code)
        -- No battery file found
        if not (exit_code == 0) then
            return
        end
        -- Periodically get battery info
        awful_widget.watch(
            "cat " .. battery_file, 4, function(_, stdout)
                local status = (stdout == 'Charging\n' or stdout == 'Not charging\n')
                if status then
                    update_interval = 60
                else
                    update_interval = 90
                end
                awesome.emit_signal("signal::charger", status)
            end
        )
    end
)
