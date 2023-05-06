local playerctl = require("module.bling.signal.playerctl")

local instance = nil

local function new_instance()
    return playerctl.lib(
        {
            player = {"youtube-music", "spotify", "mpd", "%any"}
        }
    )
end

if not instance then
    instance = new_instance()
end

return instance
