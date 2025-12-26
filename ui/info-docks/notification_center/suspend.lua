local beautiful = require("beautiful")
local gshape = require("gears.shape")

local helpers = require("helpers")

local text_icon = require("ui.widgets.text-icon")
local clickable_container = require("ui.widgets.clickable-container")

local bg_focused = beautiful.accent .. "40"

local icon = text_icon {
    text = "\u{e7f4}",
    size = 14,
    fill = 0
}

local button = clickable_container {
    widget = icon,
    shape = gshape.circle,
    margins = dpi(4),
    bg_focused = bg_focused,
    fg_focused = beautiful.accent,
    action = helpers.toggle_silent_mode
}

awesome.connect_signal(
    "notifications::suspended", function(suspended)
        if suspended then
            icon.markup = "\u{e7f6}"
            button.fg = beautiful.accent
            button.bg = bg_focused
        else
            icon.markup = "\u{e7f4}"
            button.fg = beautiful.fg
            button.bg = beautiful.black
        end

        button.focused = suspended
    end
)

return button
