-- pcall(require, "luarocks.loader")
local spawn = require("awful.spawn")
local gfs = require("gears.filesystem")
local beautiful = require("beautiful")
local naughty = require("naughty")

local revelation = require("away.third_party.revelation")

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

-- Autostart
spawn.with_shell(gfs.get_configuration_dir() .. "configuration/autostart")

-- Theme, modules and config
beautiful.init(gfs.get_configuration_dir() .. "theme/theme.lua")
revelation.init {
    charorder = "wasdhjkluiopynmftgvceqzx1234567890"
}
require("module")
require("configuration")

-- Import Daemons, UI & widgets
require("signals")
require("ui")

-- Garbage Collector Settings
collectgarbage("setpause", 110)
collectgarbage("setstepmul", 1000)
