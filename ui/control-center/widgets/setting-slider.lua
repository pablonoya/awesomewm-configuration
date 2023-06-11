local awful_button = require("awful.button")
local beautiful = require("beautiful")
local gshape = require("gears.shape")
local gtable = require("gears.table")
local wibox = require("wibox")

local clickable_container = require("ui.widgets.clickable-container")

return function(args)
    local name = wibox.widget {
        id = "name",
        text = args.name or "Action",
        font = beautiful.font_name .. "Bold 10",
        align = "left",
        widget = wibox.widget.textbox
    }

    local icon_button = clickable_container {
        widget = args.icon,
        margins = dpi(4),
        shape = gshape.circle,
        action = args.action_button
    }

    args.slider:buttons(
        gtable.join(
            awful_button({}, 4, nil, args.action_up), awful_button({}, 5, nil, args.action_down)
        )
    )

    return wibox.widget {
        {
            name,
            nil,
            {
                args.device_widget,
                width = dpi(180),
                widget = wibox.container.constraint
            },
            layout = wibox.layout.align.horizontal
        },
        {
            icon_button,
            args.slider,
            args.value_text,

            spacing = dpi(8),
            fill_space = true,
            layout = wibox.layout.fixed.horizontal
        },
        spacing = dpi(8),
        layout = wibox.layout.fixed.vertical
    }
end
