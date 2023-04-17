local watch = require("awful.widget.watch")
local beautiful = require("beautiful")
local gshape = require("gears.shape")
local wibox_layout = require("wibox.layout")
local wibox_widget = require("wibox.widget")

local function progressbar(args)
    local label = wibox_widget {
        text = args.name,
        font = beautiful.font_name .. "Bold 10",
        align = "left",
        widget = wibox_widget.textbox
    }

    local information = wibox_widget {
        text = args.info,
        font = beautiful.font_name .. 'Medium 10',
        align = "right",
        widget = wibox_widget.textbox
    }

    local slider = wibox_widget {
        min_value = args.min_value or 0,
        max_value = args.max_value or 100,
        value = args.min_value or 50,
        forced_height = dpi(20),
        color = args.slider_color,
        background_color = args.bg_color,
        shape = gshape.rounded_rect,
        bar_shape = gshape.rounded_rect,
        widget = wibox_widget.progressbar
    }

    watch(
        args.watch_command, args.interval or 1, function(_, stdout)
            local value, text = args.format_info(stdout)
            slider:set_value(value)
            information.markup = text
        end
    )

    return wibox_widget {
        {
            label,
            information,
            layout = wibox_layout.flex.horizontal
        },
        {
            args.icon_widget or {},
            slider,
            layout = wibox_layout.fixed.horizontal,
            spacing = dpi(8)
        },
        layout = wibox_layout.fixed.vertical,
        spacing = dpi(8)
    }

end

return progressbar
