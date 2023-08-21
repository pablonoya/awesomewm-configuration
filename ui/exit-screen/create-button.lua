local awful_button = require("awful.button")
local gtable = require("gears.table")
local gshape = require("gears.shape")
local beautiful = require("beautiful")
local wibox = require("wibox")

local helpers = require("helpers")
local text_icon = require("ui.widgets.text-icon")

local button_size = dpi(120)
local button_bg = beautiful.xbackground

local text_fg = beautiful.xforeground .. "C0"
local key_icon_bg = button_bg .. "D0"
local label_font = beautiful.font_name .. " 20"

return function(symbol, hover_color, key, text, command)
    local icon = text_icon {
        markup = helpers.colorize_text(symbol, hover_color),
        size = 32,
        widget = wibox.widget.textbox
    }

    local key_icon = wibox.widget {
        {
            markup = key,
            font = label_font,
            align = "center",
            widget = wibox.widget.textbox
        },
        border_color = beautiful.xforeground .. 70,
        border_width = dpi(1),
        forced_width = dpi(32),
        fg = text_fg,
        bg = key_icon_bg,
        shape = helpers.rrect(beautiful.border_radius // 4),
        widget = wibox.container.background
    }

    local label = wibox.widget {
        markup = helpers.colorize_text(text, text_fg),
        font = label_font,
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
        forced_height = button_size,
        forced_width = button_size,
        shape = gshape.circle,
        bg = button_bg,
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
            icon.markup = helpers.colorize_text(icon.text, beautiful.black)
            button.bg = hover_color

            key_icon.fg = hover_color
            key_icon.border_color = hover_color

            label.markup = helpers.colorize_text(label.text, hover_color)
        end
    )

    labeled_button:connect_signal(
        "mouse::leave", function()
            icon.markup = helpers.colorize_text(icon.text, hover_color)
            button.bg = button_bg

            key_icon.fg = text_fg
            key_icon.border_color = text_fg

            label.markup = helpers.colorize_text(label.text, text_fg)
        end
    )

    helpers.add_action(labeled_button, command)

    return labeled_button
end
