local beautiful = require("beautiful")
local gshape = require("gears.shape")
local wibox = require("wibox")

local color_helpers = require("helpers.color-helpers")

local LOCK_ICON = "\u{e897}"
local PASSWORD_ICON = "\u{f042}"
local FAILED_PASSWORD_ICON = color_helpers.colorize_text(PASSWORD_ICON, beautiful.red)

local ANIMATION_COLORS = { -- Rainbow sequence 🌈
    beautiful.red, beautiful.magenta, beautiful.accent, beautiful.cyan, beautiful.green,
    beautiful.yellow
}

local ANIMATION_DIRECTIONS = {"north", "west", "south", "east"}

local characters_entered = 0

local icon = wibox.widget {
    -- Set forced size to prevent flickering when the icon rotates
    forced_height = dpi(80),
    forced_width = dpi(80),
    markup = color_helpers.colorize_text(LOCK_ICON, beautiful.light_black),
    font = beautiful.icon_font_name .. 24,
    align = "center",
    valign = "center",
    widget = wibox.widget.textbox
}

local arc = wibox.widget {
    bg = beautiful.transparent,
    forced_width = dpi(50),
    forced_height = dpi(50),
    shape = function(cr, width, height)
        gshape.arc(cr, width, height, 5, 0, math.pi / 2, true, true)
    end,
    widget = wibox.container.background
}

local rotate = wibox.widget {
    arc,
    widget = wibox.container.rotate
}

local lock_animation = wibox.widget {
    rotate,
    icon,
    layout = wibox.layout.stack
}

-- Lock helper functions
function lock_animation.reset()
    icon.markup = color_helpers.colorize_text(LOCK_ICON, beautiful.light_black)
    rotate.direction = "north"
    arc.bg = beautiful.transparent

    characters_entered = 0
end

function lock_animation.fail()
    icon.markup = FAILED_PASSWORD_ICON
    rotate.direction = "north"
    arc.bg = beautiful.transparent

    characters_entered = 0
end

-- Function that "animates" every key press
function lock_animation.key_animation(operation)
    local arc_color

    if operation == "insert" then
        characters_entered = characters_entered + 1
        arc_color = ANIMATION_COLORS[(characters_entered % 6) + 1]
        icon.markup = PASSWORD_ICON
    elseif characters_entered > 0 then
        characters_entered = characters_entered - 1
        arc_color = beautiful.light_black
    end

    if characters_entered == 0 then
        lock_animation.reset()
        return
    end

    arc.bg = arc_color
    rotate.direction = ANIMATION_DIRECTIONS[(characters_entered % 4) + 1]
end

return lock_animation
