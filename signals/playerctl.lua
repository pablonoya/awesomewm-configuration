local naughty = require("naughty")
local playerctl = require("module.bling.signal.playerctl")

local instance = nil

local function new()
    return playerctl.lib(
        {
            update_on_activity = true,
            player = {"youtube-music", "spotify", "mpd", "%any"},
            debounce_delay = 1
        }
    )
end

if not instance then
    instance = new()
end

return instance
