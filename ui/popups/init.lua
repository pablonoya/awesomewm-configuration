local beautiful = require("beautiful")

local helpers = require("helpers")

local system_popup = require("ui.popups.system-popup")

require("ui.popups.layoutlist-popup")

local icon
local progressbar_color

awesome.connect_signal(
    "signal::volume", function(value, muted)
        if muted then
            icon = helpers.colorize_text("\u{e04f}", beautiful.light_black)
            progressbar_color = beautiful.light_black
        else
            icon = helpers.colorize_text("\u{e050}", beautiful.pop_volume_color)
            progressbar_color = beautiful.pop_volume_color
        end

        system_popup.show(icon, value, progressbar_color)
    end
)

awesome.connect_signal(
    "brightness::value", function(value)
        if value == 0 then
            icon = helpers.colorize_text("\u{e1ad}", beautiful.light_black)
            progressbar_color = beautiful.light_black
        else
            icon = helpers.colorize_text("\u{e1ac}", beautiful.moon)
            progressbar_color = beautiful.moon
        end

        system_popup.show(icon, value, progressbar_color)
    end
)

awesome.connect_signal(
    "microphone::mute", function(muted)
        if muted then
            icon = helpers.colorize_text("\u{e02b}", beautiful.light_black)
        else
            icon = helpers.colorize_text("\u{e029}", beautiful.green)
        end

        system_popup.show(icon, -1)
    end
)
