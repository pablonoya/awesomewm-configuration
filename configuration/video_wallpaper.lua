local awful_screen = require("awful.screen")
local beautiful = require("beautiful")
local spawn = require("awful.spawn")
local away_wallpaper = require("away.wallpaper")

return function(filepath)
    spawn("killall xwinwrap")

    awful_screen.connect_for_each_screen(
        function(s)
            local is_vertical = s.geometry.height > s.geometry.width
            if is_vertical and beautiful.video_wallpaper_vertical_path then
                filepath = beautiful.video_wallpaper_vertical_path
            end
            s.wallpaper = away_wallpaper.get_videowallpaper(
                s, {
                    id = "video test",
                    path = filepath,
                    player = "mpv",
                    xargs = {"-b -ov -ni -nf -un -s -st -sp"},
                    pargs = {
                        "-wid WID", "--fullscreen", "--no-stop-screensaver", "--loop", "--no-audio",
                        "--no-border", "--no-osc", "--no-osd-bar", "-name 'video-wallpaper'"
                    }
                }
            )
        end
    )
end
