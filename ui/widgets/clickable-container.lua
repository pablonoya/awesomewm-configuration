local awful_button = require("awful.button")
local beautiful = require("beautiful")
local gcolor = require("gears.color")
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
        fg = args.fg,
        shape = args.shape or gshape.rounded_rect,
        border_color = args.border_color,
        border_width = args.border_width,
        widget = wibox_container.background
    }
    container.focused = false

    -- Hover bg and fg change
    local last_bg
    local last_fg
    container:connect_signal(
        "mouse::enter", function()
            if not container.focused then
                last_bg = container.bg
                last_fg = container.fg
            end
            container.bg = args.bg_focused or gcolor.change_opacity("#d0f0ff", 0.13)
            container.fg = args.fg_focused or container.fg
        end
    )

    container:connect_signal(
        "mouse::leave", function()
            if not container.focused then
                container.bg = last_bg or args.bg or beautiful.transparent
                container.fg = last_fg or args.fg
            end
        end
    )

    if args.action then
        helpers.add_action(container, args.action)
    end

    return container
end

return clickable_container
