local spawn = require("awful.spawn")
local notification = require("naughty.notification")

local variables = require("configuration.variables")
local playerctl = require("signals.playerctl")

local actual_colors

local function extract_dominantcolors(stdout, stderr)
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

playerctl:connect_signal(
    "metadata", function(_, title, artist, album_path, album, new)
        if not actual_colors or new == true then
            spawn.easy_async_with_shell(
                variables.dominantcolors_path .. " " .. album_path, extract_dominantcolors
            )
        end
    end
)
