local spawn = require("awful.spawn")
local gfs = require("gears.filesystem")
local beautiful = require("beautiful")
local naughty = require("naughty")

-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
naughty.connect_signal(
    "request::display_error", function(message, startup)
        naughty.notification {
            urgency = "critical",
            title = "Oops, an error happened" .. (startup and " during startup!" or "!"),
            message = message
        }
    end
)

dpi = beautiful.xresources.apply_dpi

-- Autostart programs
spawn.with_shell(gfs.get_configuration_dir() .. "configuration/autostart.sh")

-- Theme + Configs
beautiful.init(gfs.get_configuration_dir() .. "theme/theme.lua")
require("bindings")
require("configuration")

-- Import UI + Signals
require("ui")
require("signals")

-- Garbage Collector Settings
collectgarbage("setpause", 110)
collectgarbage("setstepmul", 1000)
