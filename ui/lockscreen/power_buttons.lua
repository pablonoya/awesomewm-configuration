local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")

local color_helpers = require("helpers.color-helpers")
local helpers = require("helpers")
local system_controls = require("helpers.system_controls")

local text_icon = require("ui.widgets.text-icon")

local function icon_button(icon, color, onclick)
    local button = wibox.widget {
        text_icon {
            markup = color_helpers.colorize_text(icon, color),
            size = 24
        },
        forced_width = dpi(48),
        forced_height = dpi(48),
        shape = helpers.rrect(beautiful.border_radius - 2),
        widget = wibox.container.background
    }

    button:connect_signal(
        "mouse::enter", function()
            button.bg = color .. "32"
        end
    )

    button:connect_signal(
        "mouse::leave", function()
            button.bg = beautiful.transparent
        end
    )

    helpers.add_action(button, onclick)

    return button
end

local power_buttons = wibox.widget {
    {
        {
            icon_button("\u{e8ac}", beautiful.red, system_controls.poweroff),
            icon_button("\u{f053}", beautiful.yellow, system_controls.reboot),
            icon_button("\u{ef44}", beautiful.magenta, system_controls.suspend),
            icon_button("\u{e9ba}", beautiful.blue, awesome.quit),

            layout = wibox.layout.fixed.horizontal
        },
        -- left = dpi(4),
        -- right = dpi(4),
        margins = dpi(8),
        widget = wibox.container.margin
    },
    border_width = dpi(2),
    border_color = beautiful.focus,
    bg = beautiful.xbackground,
    shape = helpers.rrect(beautiful.border_radius),
    widget = wibox.container.background
}

return {
    power_buttons,
    nil,
    layout = wibox.layout.fixed.horizontal
}
