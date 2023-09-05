local spawn = require("awful.spawn")
local beautiful = require("beautiful")
local notification = require("naughty.notification")

local playerctl = require("signals.playerctl")

local actual_colors

playerctl:connect_signal(
    "metadata", function(_, title, artist, album_path, album, new)
        if not actual_colors or new == true then
            spawn.easy_async_with_shell(
                beautiful.dominantcolors_path .. " " .. album_path, function(stdout, stderr)
                    if stderr ~= "" then
                        notification {
                            text = stderr,
                            urgency = "critical"
                        }
                        return
                    end

                    if stdout == "" or not string.match(stdout, "^#") or actual_colors == stdout then
                        return
                    end

                    local colors = {}
                    for color in stdout:gmatch("[^\n]+") do
                        table.insert(colors, color)
                    end

                    awesome.emit_signal("media::dominantcolors", colors)
                    actual_colors = stdout
                end
            )
        end
    end
)
