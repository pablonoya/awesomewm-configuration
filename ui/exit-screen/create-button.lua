local awful_button = require("awful.button")
local gtable = require("gears.table")
local gshape = require("gears.shape")
local beautiful = require("beautiful")
local wibox = require("wibox")

local helpers = require("helpers")
local text_icon = require("ui.widgets.text-icon")

local button_size = dpi(120)
local button_bg = beautiful.xbackground

return function(symbol, hover_color, text, command)
    local icon = text_icon {
        markup = helpers.colorize_text(symbol, hover_color),
        size = 32,
        widget = wibox.widget.textbox
    }

    local button = wibox.widget {
        {
            {
                icon,
                layout = wibox.container.place
            },
            id = "container",
            forced_height = button_size,
            forced_width = button_size,
            shape = gshape.circle,
            bg = beautiful.xbackground,
            border_width = beautiful.widget_border_width,
            border_color = beautiful.focus,
            widget = wibox.container.background
        },
        {
            id = "label",
            markup = helpers.colorize_text(text, beautiful.xforeground .. 75),
            font = beautiful.font_name .. " 20",
            forced_width = button_size,
            align = "center",
            widget = wibox.widget.textbox
        },
        spacing = dpi(8),
        layout = wibox.layout.align.vertical,
        widget = wibox.container.background

    }

    button:buttons(gtable.join(awful_button({}, 1, command)))

    button:connect_signal(
        "mouse::enter", function()
            icon.markup = helpers.colorize_text(icon.text, beautiful.black)
            button.label.markup = helpers.colorize_text(text, hover_color)
            button.container.bg = hover_color
        end
    )

    button:connect_signal(
        "mouse::leave", function()
            icon.markup = helpers.colorize_text(icon.text, hover_color)
            button.label.markup = helpers.colorize_text(text, beautiful.xforeground .. 75)
            button.container.bg = beautiful.xbackground
        end
    )

    button:connect_signal(
        "button::press", function()
            button.container.bg = hover_color
        end
    )

    helpers.add_hover_cursor(button, "hand1")

    return button
end
