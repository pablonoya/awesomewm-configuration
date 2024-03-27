local beautiful = require("beautiful")
local variables = require("configuration.variables")

-- Set static wallpaper if there is no video wallpaper path
if not variables.videowallpaper_path then
    screen.connect_signal(
        "request::wallpaper", function(s)
            local awful_wallpaper = require("awful.wallpaper")

            awful_wallpaper {
                screen = s,
                bg = beautiful.black
            }
        end
    )
    return
end

local away_wallpaper = require("away.wallpaper")

local spawn = require("awful.spawn")
local gtimer = require("gears.timer")

-- Remove any previous xwinwrap processes
spawn("pkill xwinwrap")

screen.connect_signal(
    "request::wallpaper", function(s)
        if s.videowallpaper then
            s.videowallpaper.update()
            return
        end

        local vertical_screen = s.geometry.height > s.geometry.width
        local filepath = (vertical_screen and variables.videowallpaper_vertical_path
                             or variables.videowallpaper_path)

        s.videowallpaper = away_wallpaper.get_videowallpaper(
            s, {
                id = "video test",
                path = filepath,
                player = "mpv",
                xargs = {"-b", "-ov", "-ni", "-s"},
                pargs = {
                    "-wid WID", "--no-stop-screensaver", "--loop", "--no-audio", "--hwdec=auto",
                    "--really-quiet", "--player-operation-mode=cplayer"
                }
            }
        )
    end
)

screen.connect_signal(
    "removed", function(s)
        if s.videowallpaper and s.videowallpaper.pid then
            spawn("kill " .. s.videowallpaper.pid)
        end
    end
)

-- Wait 4 seconds for the wallpaper to be set before loading video pausing helpers
gtimer {
    timeout = 4,
    autostart = true,
    single_shot = true,
    callback = function()
        if screen[1].videowallpaper.pid then
            require("helpers.video_pausing_helpers")
        end
    end
}
