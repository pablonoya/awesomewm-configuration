local spawn = require("awful.spawn")
local gfs = require("gears.filesystem")
local notification = require("naughty.notification")

local playerctl = require("signals.playerctl")
local color_helpers = require("helpers.color-helpers")

local CONFIG_DIR = gfs.get_configuration_dir()

local actual_colors

playerctl:connect_signal(
    "metadata", function(_, title, artist, album_path, album, new)
        if not actual_colors or new == true then
            spawn.easy_async_with_shell(
                "$HOME/.local/bin/dominantcolors " .. album_path, function(stdout, stderr)
                    if stderr ~= "" then
                        notification {
                            text = stderr,
                            urgency = "critical"
                        }
                    end

                    if stdout == "" or not string.match(stdout, "^#") then
                        return
                    end

                    if actual_colors == stdout then
                        return
                    end

                    actual_colors = stdout
                    awesome.emit_signal("media::dominantcolors", actual_colors)
                end
            )
        end
    end
)
