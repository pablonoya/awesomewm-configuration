local spawn = require("awful.spawn")
local beautiful = require("beautiful")
local gfs = require("gears.filesystem")

spawn("pkill xwinwrap")
spawn("pkill pause_videowall")

local function set_static_wallpaper(s)
    local awful_wallpaper = require("awful.wallpaper")

    awful_wallpaper {
        screen = s,
        bg = beautiful.black
    }
end

local function set_videowallpaper(s)
    local filepath = beautiful.videowallpaper_path

    if not filepath then
        set_static_wallpaper(s)
        return
    end

    if s.videowallpaper then
        s.videowallpaper.update()
        return
    end

    local away_wallpaper = require("away.wallpaper")
    local vertical_screen = s.geometry.height > s.geometry.width

    if vertical_screen and beautiful.videowallpaper_vertical_path then
        filepath = beautiful.videowallpaper_vertical_path
    end

    s.videowallpaper = away_wallpaper.get_videowallpaper(
        s, {
            id = "video test",
            path = filepath,
            player = "mpv",
            xargs = {"-b -ov -ni -nf -un -s -st -sp"},
            pargs = {
                "-wid WID", "--fullscreen", "--no-stop-screensaver", "--loop", "--no-audio",
                "--hwdec=auto", "--vo=gpu", "--no-border", "--no-osc", "--no-osd-bar"
            }
        }
    )

    --  pause mpv if there are open windows
    spawn.easy_async(
        "pgrep pause_videowall", function(stdout)
            if stdout == "" then
                spawn.once(gfs.get_configuration_dir() .. "configuration/pause_videowallpaper.sh")
            end
        end
    )
end

local function remove_wallpaper(s)
    if s.videowallpaper and s.videowallpaper.pid then
        spawn("kill " .. s.videowallpaper.pid)
    end
end

screen.connect_signal("request::wallpaper", set_videowallpaper)
screen.connect_signal("removed", remove_wallpaper)
