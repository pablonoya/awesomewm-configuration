local awful = require("awful")

local should_pause = false
local paused = false

local focused_screen = awful.screen.focused()

local function pause_video(should_pause)
    if should_pause ~= paused then
        awful.spawn("xdotool search --class mpv key --window %@ p")
        paused = not paused
    end
    should_pause = false
end

-- Pause if there are open windows on focused screen
pause_video(#awful.client.visible(focused_screen) > 0)

-- Pause if there are open windows on focused tag
screen.connect_signal(
    "tag::history::update", function(s)
        pause_video(#awful.client.visible(s) > 0)
    end
)

-- Pause on every new client
tag.connect_signal(
    "tagged", function(c)
        pause_video(true)
    end
)

-- Unpause if there are no clients after a client is closed
tag.connect_signal(
    "untagged", function(c)
        pause_video(#awful.client.visible(c.screen) > 0)
    end
)
