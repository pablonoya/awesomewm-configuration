local button = require("awful.button")
local beautiful = require("beautiful")
local gtable = require("gears.table")
local wibox = require("wibox")

local helpers = require("helpers")

local function toggle_button(icon, name, bg_color, onclick, signal, signal_label)
    local action = wibox.widget {
        text = name,
        font = beautiful.font_name .. " Bold 10",
        align = "left",
        widget = wibox.widget.textbox
    }

    local icon = wibox.widget {
        markup = icon,
        font = beautiful.icon_font,
        widget = wibox.widget.textbox
    }

    local filled_button = wibox.widget {
        {
            {
                icon,
                action,
                spacing = dpi(8),
                layout = wibox.layout.fixed.horizontal
            },
            margins = dpi(12),
            widget = wibox.container.margin
        },
        bg = beautiful.control_center_button_bg,
        shape = helpers.rrect(beautiful.border_radius),
        widget = wibox.container.background
    }

    filled_button:buttons(gtable.join(button({}, 1, nil, onclick)))
    helpers.add_hover_cursor(filled_button)

    local toggle = function(state)
        if state then
            filled_button.bg = bg_color
            filled_button.fg = beautiful.xbackground
        else
            filled_button.bg = beautiful.control_center_button_bg
            filled_button.fg = beautiful.xforeground
            action.text = name
        end
    end

    signal(toggle)

    if signal_label then
        awesome.connect_signal(
            signal_label, function(label)
                action.text = label
            end
        )
    end

    return filled_button
end

return toggle_button
