local beautiful = require("beautiful")
local gshape = require("gears.shape")
local wibox_widget = require("wibox.widget")

local helpers = require("helpers")

return function(args)
    local slider = wibox_widget {
        maximum = args.max or 100,
        shape = gshape.rounded_bar,
        forced_height = dpi(24),
        forced_width = dpi(220),

        bar_color = args.bar_bg_color,
        bar_active_color = args.bar_color,
        bar_shape = gshape.rounded_bar,
        bar_height = args.bar_height or dpi(4),

        handle_color = args.handle_color,
        handle_shape = gshape.circle,
        handle_width = args.handle_width or dpi(16),
        handle_border_color = args.handle_border_color or beautiful.black,
        handle_border_width = args.handle_border_width or dpi(2),

        widget = wibox_widget.slider
    }

    local original_handle_width
    helpers.add_hover_cursor(slider)
    slider:connect_signal(
        "mouse::enter", function()
            original_handle_width = slider.handle_width
            slider.handle_width = slider.handle_width + 1
        end
    )

    slider:connect_signal(
        "mouse::leave", function()
            slider.handle_width = original_handle_width
        end
    )

    return slider
end
