local beautiful = require("beautiful")
local wibox_widget = require("wibox.widget")
local wibox_container = require("wibox.container")

return function(args)
    return wibox_widget {
        {
            id = "text",
            markup = args.markup or args.text or "Text",
            font = args.font or beautiful.font,
            valign = "center",
            widget = wibox_widget.textbox
        },
        fps = args.fps,
        speed = args.speed or 16,
        extra_space = args.extra_space,
        expand = true,
        max_size = args.max_size,
        step_function = args.step_function,
        forced_width = args.forced_width,
        widget = wibox_container.scroll.horizontal
    }
end
