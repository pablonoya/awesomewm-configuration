local gfs = require("gears.filesystem")
local dir = gfs.get_configuration_dir() .. "icons/media/"

local mapping = {
    firefox = dir .. "firefox.svg",
    music_note = dir .. "music-note.svg"
}

mapping['youtube-music'] = dir .. "youtube-music.svg"

return mapping
