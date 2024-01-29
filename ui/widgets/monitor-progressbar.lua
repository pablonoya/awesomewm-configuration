local spawn = require("awful.spawn")
local beautiful = require("beautiful")
local gshape = require("gears.shape")
local gtimer = require("gears.timer")
local wibox_layout = require("wibox.layout")
local wibox_widget = require("wibox.widget")

local function monitor_progressbar(args)
    local label = wibox_widget {
        text = args.name,
        font = beautiful.font_name .. "Bold 10",
        align = "left",
        widget = wibox_widget.textbox
    }

    local information = wibox_widget {
        text = args.info,
        font = beautiful.font_name .. "Medium 10",
        align = "right",
        widget = wibox_widget.textbox
    }

    local progressbar = wibox_widget {
        min_value = args.min_value or 0,
        max_value = args.max_value or 100,
        forced_height = dpi(20),
        color = args.slider_color,
        background_color = args.bg_color,
        shape = gshape.rounded_rect,
        bar_shape = gshape.rounded_rect,
        widget = wibox_widget.progressbar
    }

    local function callback()
        spawn.easy_async_with_shell(
            args.watch_command, function(stdout)
                local value, text = args.format_info(stdout)
                progressbar:set_value(value)
                information.markup = text
            end
        )
    end

    local timer = gtimer {
        timeout = args.interval or 1,
        call_now = true,
        callback = callback
    }

    awesome.connect_signal(
        "control_center::monitor_mode", function(monitor_mode)
            if monitor_mode then
                -- run callback immediately then periodically
                callback()
                timer:start()
            else
                timer:stop()
            end
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
            progressbar,
            layout = wibox_layout.fixed.horizontal,
            spacing = dpi(8)
        },
        layout = wibox_layout.fixed.vertical,
        spacing = dpi(6)
    }
end

return monitor_progressbar
