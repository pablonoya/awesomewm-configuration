local beautiful = require("beautiful")
local gshape = require("gears.shape")
local wibox = require("wibox")

local helpers = require("helpers")
local color_helpers = require("helpers.color-helpers")
local text_icon = require("ui.widgets.text-icon")

local SIZE = dpi(120)
local BG = beautiful.xbackground

local FG = beautiful.xforeground .. "C0"
local BG_KEY_ICON = BG .. "D0"
local LABEL_FONT = beautiful.font_name .. 20

return function(symbol, hover_color, key, text, command)
    local icon = text_icon {
        markup = color_helpers.colorize_text(symbol, hover_color),
        size = 32,
        widget = wibox.widget.textbox
    }

    local key_icon = wibox.widget {
        {
            markup = key,
            font = LABEL_FONT,
            halign = "center",
            valign = "center",
            widget = wibox.widget.textbox
        },
        border_color = FG,
        border_width = dpi(1.6),
        forced_width = dpi(32),
        fg = FG,
        bg = BG_KEY_ICON,
        shape = helpers.rrect(beautiful.border_radius // 4),
        widget = wibox.container.background
    }

    local label = wibox.widget {
        markup = color_helpers.colorize_text(text, FG),
        font = LABEL_FONT,
        widget = wibox.widget.textbox
    }

    local button_label = wibox.widget {
        {
            key_icon,
            label,
            spacing = dpi(2),
            layout = wibox.layout.fixed.horizontal,
            widget = wibox.container.background
        },
        widget = wibox.container.place
    }

    local button = wibox.widget {
        {
            icon,
            layout = wibox.container.place
        },
        forced_height = SIZE,
        forced_width = SIZE,
        shape = gshape.circle,
        bg = BG,
        border_width = beautiful.widget_border_width,
        border_color = hover_color,
        widget = wibox.container.background
    }

    local labeled_button = wibox.widget {
        button,
        button_label,
        spacing = dpi(12),
        layout = wibox.layout.fixed.vertical,
        widget = wibox.container.background
    }

    labeled_button:connect_signal(
        "mouse::enter", function()
            icon.markup = color_helpers.colorize_text(icon.text, beautiful.black)
            button.bg = hover_color

            key_icon.fg = hover_color
            key_icon.border_color = hover_color

            label.markup = color_helpers.colorize_text(label.text, hover_color)
        end
    )

    labeled_button:connect_signal(
        "mouse::leave", function()
            icon.markup = color_helpers.colorize_text(icon.text, hover_color)
            button.bg = BG

            key_icon.fg = FG
            key_icon.border_color = FG

            label.markup = color_helpers.colorize_text(label.text, FG)
        end
    )

    helpers.add_action(
        labeled_button, function()
            awesome.emit_signal("exit_screen::hide")
            command()
        end
    )

    return labeled_button
end
