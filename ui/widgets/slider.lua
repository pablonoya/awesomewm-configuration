local beautiful = require("beautiful")
local gshape = require("gears.shape")
local wibox_widget = require("wibox.widget")

return function(args)
    return wibox_widget {
        maximum = args.max or 100,
        shape = gshape.rounded_bar,
        forced_height = dpi(24),
        forced_width = dpi(220),

        bar_color = args.bar_bg_color,
        bar_active_color = args.bar_color,
        bar_shape = gshape.rounded_bar,
        bar_height = dpi(4),

        handle_color = args.handle_color,
        handle_shape = gshape.circle,
        handle_width = dpi(16),
        handle_border_color = beautiful.xbackground,
        handle_border_width = dpi(2),

        widget = wibox_widget.slider
    }
end
