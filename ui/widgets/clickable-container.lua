local awful_button = require("awful.button")
local beautiful = require("beautiful")
local gshape = require("gears.shape")
local gtable = require("gears.table")
local wibox_container = require("wibox.container")
local wibox_widget = require("wibox.widget")

local helpers = require("helpers")

local function clickable_container(args)
    local container = wibox_widget {
        {
            args.widget,
            margins = args.margins or 0,
            widget = wibox_container.margin
        },
        bg = args.bg or beautiful.transparent,
        fg = args.fg or beautiful.xforeground,
        shape = args.shape or gshape.rounded_rect,
        widget = wibox_container.background
    }
    container.focused = false

    helpers.add_hover_cursor(container, "hand2")

    -- Hover bg change
    container:connect_signal(
        "mouse::enter", function()
            container.bg = args.bg_focused or beautiful.focus
            container.fg = args.fg_focused or beautiful.xforeground
        end
    )

    container:connect_signal(
        "mouse::leave", function()
            if not container.focused then
                container.bg = args.bg or beautiful.transparent
                container.fg = args.fg or beautiful.xforeground
            end
        end
    )

    container:connect_signal(
        "button::press", function()
            container.bg = beautiful.focus .. 'B0'
        end
    )

    if args.action then
        container:buttons(gtable.join(awful_button({}, 1, nil, args.action)))
    end

    return container
end

return clickable_container
