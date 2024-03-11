local spawn = require("awful.spawn")
local beautiful = require("beautiful")
local gshape = require("gears.shape")
local gtimer = require("gears.timer")
local wibox = require("wibox")

local rubato = require("module.rubato")

return function(args)
    local label = wibox.widget {
        text = args.name,
        font = beautiful.font_name .. "Bold 10",
        align = "left",
        widget = wibox.widget.textbox
    }

    local information = wibox.widget {
        text = args.info,
        font = beautiful.font_name .. "Medium 10",
        align = "right",
        widget = wibox.widget.textbox
    }

    local progressbar = wibox.widget {
        min_value = args.min_value or 0,
        max_value = args.max_value or 100,
        forced_height = dpi(20),
        color = args.slider_color,
        background_color = args.bg_color,
        shape = gshape.rounded_rect,
        bar_shape = gshape.rounded_rect,
        widget = wibox.widget.progressbar
    }

    local slide = rubato.timed {
        rate = 60,
        duration = 0.4,
        easing = rubato.easing.quadratic,
        subscribed = function(val)
            progressbar:set_value(val)
        end
    }

    local function callback()
        spawn.easy_async_with_shell(
            args.watch_command, function(stdout)
                local value, text = args.format_info(stdout)
                slide.target = value
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

    return wibox.widget {
        {
            label,
            information,
            layout = wibox.layout.flex.horizontal
        },
        {
            args.icon_widget or {},
            progressbar,
            layout = wibox.layout.fixed.horizontal,
            spacing = dpi(8)
        },
        layout = wibox.layout.fixed.vertical,
        spacing = dpi(6)
    }
end
