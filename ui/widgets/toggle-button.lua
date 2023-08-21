local button = require("awful.button")
local beautiful = require("beautiful")
local gtable = require("gears.table")
local gcolor = require("gears.color")
local wibox = require("wibox")

local helpers = require("helpers")

local clickable_container = require("ui.widgets.clickable-container")
local text_icon = require("ui.widgets.text-icon")

local function toggle_button(icon, name, bg_color, onclick, signal, signal_label)
    local button_fg = beautiful.xforeground
    local button_bg = beautiful.control_center_button_bg
    local hover_bg = gcolor.change_opacity(bg_color, 0.4)

    local action = wibox.widget {
        text = name,
        font = beautiful.font_name .. " Bold 10",
        widget = wibox.widget.textbox
    }

    local icon = text_icon {
        markup = icon,
        size = 16
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

    helpers.add_action(filled_button, onclick)

    local toggle = function(state)
        if state then
            filled_button.bg = bg_color
            filled_button.fg = beautiful.xbackground
            hover_bg = gcolor.change_opacity(bg_color, 0.8)
        else
            filled_button.bg = beautiful.control_center_button_bg
            filled_button.fg = beautiful.xforeground
            action.text = name
            hover_bg = gcolor.change_opacity(bg_color, 0.4)
        end

        button_bg = filled_button.bg
        button_fg = filled_button.fg
    end

    signal(toggle)

    if signal_label then
        awesome.connect_signal(
            signal_label, function(label)
                action.text = label
            end
        )
    end

    filled_button:connect_signal(
        "mouse::enter", function()
            filled_button.bg = hover_bg
        end
    )

    filled_button:connect_signal(
        "mouse::leave", function()
            filled_button.bg = button_bg
            filled_button.fg = button_fg
        end
    )

    return filled_button
end

return toggle_button
