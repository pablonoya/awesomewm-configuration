local beautiful = require("beautiful")
local video_wallpaper = require("configuration.video_wallpaper")

video_wallpaper(beautiful.video_wallpaper_path)

require("configuration.keys")
require("configuration.ruled")
require("configuration.tags")
require("configuration.clients")
require("configuration.extras")
