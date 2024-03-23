local gfs = require("gears.filesystem")
local dir = gfs.get_configuration_dir() .. "ui/icons/media/"

return {
    firefox = dir .. "firefox.svg",
    music_note = dir .. "music-note.svg",
    ["youtube-music"] = dir .. "youtube-music.svg",
    ["YoutubeMusic"] = dir .. "youtube-music.svg"
}
