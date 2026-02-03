local spawn = require("awful.spawn")
local notification = require("naughty.notification")

local variables = require("configuration.variables")
local playerctl = require("signals.playerctl")

local function extract_dominantcolors(stdout, stderr)
    if stderr ~= "" then
        notification {
            title = "dominantcolors error",
            text = stderr,
            urgency = "critical"
        }
        return
    end

    if not string.match(stdout, "^#") then
        return
    end

    local colors = {}
    for color in stdout:gmatch("#%x%x%x%x%x%x") do
        colors[#colors + 1] = color
    end

    awesome.emit_signal("media::dominantcolors", colors)
end

playerctl:connect_signal(
    "metadata", function(_, title, artist, album_path, album, new)
        if not album_path or album_path == "" then
            return
        end

        spawn.easy_async_with_shell(
            variables.dominantcolors_path .. " -c 3.5 " .. album_path, extract_dominantcolors
        )
    end
)
