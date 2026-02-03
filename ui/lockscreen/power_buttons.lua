local beautiful = require("beautiful")
local wibox = require("wibox")

local helpers = require("helpers")
local color_helpers = require("helpers.color-helpers")
local system_controls = require("helpers.system_controls")

local battery = require("ui.bar.widgets.battery")
local text_icon = require("ui.widgets.text-icon")
local border_container = require("ui.widgets.border-container")

local function icon_button(icon, color, onclick)
    local button = wibox.widget {
        text_icon {
            markup = color_helpers.colorize_text(icon, color),
            size = 28
        },
        forced_width = dpi(52),
        forced_height = dpi(48),
        shape = helpers.rrect(beautiful.border_radius - 4),
        widget = wibox.container.background
    }

    button:connect_signal(
        "mouse::enter", function()
            button.bg = color .. "28"
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

local power_buttons = border_container {
    widget = {
        icon_button("\u{e8ac}", beautiful.red, system_controls.poweroff),
        icon_button("\u{f053}", beautiful.yellow, system_controls.reboot),
        icon_button("\u{ef44}", beautiful.magenta, system_controls.suspend),
        icon_button("\u{e9ba}", beautiful.blue, awesome.quit),

        layout = wibox.layout.fixed.horizontal
    },
    margins = dpi(8),
    border_width = dpi(2)
}

local battery_container = border_container {
    widget = battery(false),
    border_width = dpi(2),
    shape = helpers.rrect(beautiful.border_radius - 4)
}

return {
    power_buttons,
    battery_container,
    spacing = dpi(12),
    layout = wibox.layout.fixed.horizontal
}
