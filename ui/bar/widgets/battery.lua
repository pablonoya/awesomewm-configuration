local awful_button = require("awful.button")
local spawn = require("awful.spawn")
local beautiful = require("beautiful")
local gshape = require("gears.shape")
local gtable = require("gears.table")
local notification = require("naughty.notification")
local wibox = require("wibox")

local helpers = require("helpers")
local system_controls = require("helpers.system-controls")

local is_charging = false
local last_value = 50
local low_value = 20
local critical_value = 15

local percentage = wibox.widget {
    font = beautiful.font_name .. "Bold 12",
    halign = "center",
    visible = false,
    widget = wibox.widget.textbox
}

local charge_icon = wibox.widget {
    font = beautiful.icon_font_name .. 17,
    markup = helpers.colorize_text("\u{ea0b}", beautiful.green),
    halign = "center",
    visible = false,
    widget = wibox.widget.textbox
}

local battery_bar = wibox.widget {
    max_value = 100,
    value = last_value,
    paddings = 2.6,
    forced_width = dpi(32),
    forced_height = dpi(23),
    color = beautiful.green,
    background_color = beautiful.green .. '10',
    shape = helpers.rrect(4),
    bar_shape = helpers.rrect(2),
    border_width = dpi(1),
    border_color = beautiful.green,
    widget = wibox.widget.progressbar
}

local positive_connection = wibox.widget {
    id = "positive_connection",
    forced_height = dpi(8),
    forced_width = dpi(8),
    bg = beautiful.green,
    shape = function(cr, width, height)
        return gshape.pie(cr, width, height, -math.pi / 2, math.pi / 2)
    end,
    widget = wibox.container.background
}

return function(is_vertical)
    local battery_body = {
        {
            battery_bar,
            percentage,
            charge_icon,
            layout = wibox.layout.stack
        },
        {
            positive_connection,
            left = dpi(-2),
            widget = wibox.container.margin
        },
        layout = wibox.layout.fixed.horizontal
    }

    if is_vertical then
        battery_body = {
            battery_body,
            direction = "east",
            widget = wibox.container.rotate
        }
    end

    local battery_widget = wibox.widget {
        battery_body,
        widget = wibox.container.place
    }

    battery_widget:buttons(
        -- Change brightness on scrolling
        gtable.join(
            awful_button(
                {}, 4, function()
                    system_controls.brightness_control("increase")
                end
            ), awful_button(
                {}, 5, function()
                    system_controls.brightness_control("decrease")
                end
            )
        )
    )

    battery_widget:connect_signal(
        "mouse::enter", function()
            percentage.visible = true
            charge_icon.visible = false
        end
    )

    battery_widget:connect_signal(
        "mouse::leave", function()
            percentage.visible = false
            charge_icon.visible = is_charging
        end
    )

    awesome.connect_signal(
        "signal::battery", function(value)
            battery_bar.value = value
            last_value = value

            local color = beautiful.green
            if charge_icon.visible then
                color = beautiful.cyan

            elseif value <= critical_value then
                color = beautiful.red
                if not charge_icon.visible then
                    notification {
                        text = "VERY low battery!",
                        urgency = "critical"
                    }
                end

            elseif value <= low_value then
                color = beautiful.yellow
            end

            if color ~= nil then
                percentage:set_markup_silently(helpers.colorize_text(value, color))
                positive_connection.bg = color
                battery_bar.color = color .. '70'
                battery_bar.background_color = color .. '10'
                battery_bar.border_color = color
            end
        end
    )

    awesome.connect_signal(
        "signal::charger", function(state)
            is_charging = state
            charge_icon.visible = not percentage.visible and is_charging
        end
    )

    return {
        battery_widget,
        left = dpi(4),
        right = dpi(6),
        widget = wibox.container.margin
    }
end
