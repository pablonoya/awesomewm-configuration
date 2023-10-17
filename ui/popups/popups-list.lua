local beautiful = require("beautiful")

local color_helpers = require("helpers.color-helpers")
local ui_helpers = require("helpers.ui-helpers")

local system_popup = require("ui.popups.system-popup")

local icon_markup
local progressbar_color

awesome.connect_signal(
    "signal::volume", function(value, muted)
        if muted then
            icon_markup = color_helpers.colorize_text("\u{e04f}", beautiful.focus)
            progressbar_color = beautiful.focus
        else
            icon_markup = color_helpers.colorize_text(
                ui_helpers.get_volume_icon(value), beautiful.popup_volume_color
            )
            progressbar_color = beautiful.popup_volume_color
        end

        system_popup.show(icon_markup, value, progressbar_color)
    end
)

awesome.connect_signal(
    "brightness::value", function(value)
        if value == 0 then
            icon_markup = color_helpers.colorize_text("\u{e1ad}", beautiful.focus)
            progressbar_color = beautiful.focus
        else
            icon_markup = color_helpers.colorize_text(
                ui_helpers.get_brightness_icon(value), beautiful.popup_brightness_color
            )
            progressbar_color = beautiful.popup_brightness_color
        end

        system_popup.show(icon_markup, value, progressbar_color)
    end
)

awesome.connect_signal(
    "microphone::mute", function(muted)
        if muted then
            icon_markup = color_helpers.colorize_text("\u{e02b}", beautiful.focus)
        else
            icon_markup = color_helpers.colorize_text("\u{e029}", beautiful.popup_mic_color)
        end

        system_popup.show(icon_markup, -1)
    end
)

awesome.connect_signal(
    "brightness::keyboard", function(value)
        icon_markup = color_helpers.colorize_text(
            value < 50 and "\u{f7ec}" or "\u{f7ed}", beautiful.white
        )
        progressbar_color = beautiful.white
        system_popup.show(icon_markup, value, progressbar_color)
    end
)
