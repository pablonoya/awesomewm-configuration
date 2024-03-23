local awful = require("awful")

local should_pause = false
local paused = false

local focused_screen = awful.screen.focused()

local function pause_video(should_pause)
    if should_pause ~= paused then
        awful.spawn.with_shell("sleep 0.3 ; xdotool search --class mpv key --window %@ p")
        paused = not paused
        should_pause = false
    end
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
        if c.screen == awful.screen.focused() then
            pause_video(not c.minimized)
        end
    end
)

-- Unpause if there are no clients after a client is closed
tag.connect_signal(
    "untagged", function(c)
        if c.screen == awful.screen.focused() then
            pause_video(#awful.client.visible(c.screen) > 0)
        end
    end
)
