local spawn = require("awful.spawn")
local awful_widget = require("awful.widget")

local update_interval = 40

spawn.easy_async_with_shell(
    "echo /sys/class/power_supply/BAT?/status | head -1 || false",
        function(battery_file, _, __, exit_code)
            -- No battery file found
            if not (exit_code == 0) then
                return
            end

            -- Periodically get battery info
            awful_widget.watch(
                "cat " .. battery_file, 5, function(_, stdout)
                    local status = (stdout == "Charging\n" or stdout == "Not charging\n")

                    -- increase update_interval if charging
                    update_interval = status and 60 or 40

                    awesome.emit_signal("signal::charger", status)
                end
            )
        end
)

spawn.easy_async_with_shell(
    "echo /sys/class/power_supply/BAT?/capacity | head -1 || false",
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
