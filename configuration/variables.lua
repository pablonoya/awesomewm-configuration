local gfs = require("gears.filesystem")

local HOME = os.getenv("HOME")

return {
    editor = "code",
    file_manager = "thunar",
    terminal = "wezterm-gui",

    pfp = gfs.get_configuration_dir() .. "ui/assets/kirbeats.jpg",

    latitude = 12.345,
    longitude = -67.890

    -- Optional variables
    -- Video wallpaper
    -- videowallpaper_path = HOME .. "/Videos/cyberpunk-city-pixel.mp4",
    -- videowallpaper_vertical_path = HOME .. "/Videos/cyberpunk-city-pixel-vertical.mp4",

    -- Dominantcolors script path
    -- dominantcolors_path = HOME .. "/.local/bin/dominantcolors",

    -- gcalendar requires output in json
    -- gcalendar_command = "gcalendar --output json --no-of-days 3",

    -- OpenWeather api key
    -- weather_api_key = "y0ur4p1k3yc0m35h3r3"
}
