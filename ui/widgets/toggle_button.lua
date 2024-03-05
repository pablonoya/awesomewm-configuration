local beautiful = require("beautiful")
local gcolor = require("gears.color")
local wibox = require("wibox")

local helpers = require("helpers")

local scrolling_text = require("ui.widgets.scrolling-text")
local text_icon = require("ui.widgets.text-icon")

return function(args)
    local bg_color = args.active_color or beautiful.accent
    local last_fg = beautiful.xforeground
    local last_bg = beautiful.control_center_button_bg
    local hover_bg = gcolor.change_opacity(bg_color, 0.4)

    local icon = text_icon {
        markup = args.icon,
        size = 16
    }

    local action = scrolling_text {
        text = args.name,
        font = beautiful.font_name .. " Bold 10",
        forced_width = dpi(100)
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

    -- Change color on hover
    filled_button:connect_signal(
        "mouse::enter", function()
            filled_button.bg = hover_bg
        end
    )

    filled_button:connect_signal(
        "mouse::leave", function()
            filled_button.bg = last_bg
            filled_button.fg = last_fg
        end
    )

    local function toggle(value)
        if value and value ~= "" then
            filled_button.bg = bg_color
            filled_button.fg = beautiful.xbackground
            hover_bg = gcolor.change_opacity(bg_color, 0.8)
        else
            filled_button.bg = beautiful.control_center_button_bg
            filled_button.fg = beautiful.xforeground
            hover_bg = gcolor.change_opacity(bg_color, 0.4)

        end

        if type(value) == "string" then
            action.text:set_markup(value)
        else
            action.text:set_markup(args.name)
        end

        last_bg = filled_button.bg
        last_fg = filled_button.fg
    end

    awesome.connect_signal(args.signal_label, toggle)
    helpers.add_action(filled_button, args.onclick)

    return filled_button
end
