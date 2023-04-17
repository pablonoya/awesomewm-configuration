local awful_button = require("awful.button")
local spawn = require("awful.spawn")
local beautiful = require("beautiful")
local gshape = require("gears.shape")
local gtable = require("gears.table")
local notification = require("naughty.notification")
local wibox = require("wibox")

local helpers = require("helpers")
local system_controls = require("helpers.system-controls")

local percentaje = wibox.widget {
    font = beautiful.font_name .. "Bold 12",
    align = "center",
    widget = wibox.widget.textbox
}

local charge_icon = wibox.widget {
    font = beautiful.icon_font_name .. "12",
    markup = helpers.colorize_text("", beautiful.yellow),
    align = "left",
    visible = false,
    widget = wibox.widget.textbox()
}

local battery_bar = wibox.widget {
    max_value = 100,
    value = 50,
    paddings = 2.5,
    forced_width = dpi(28),
    forced_height = dpi(20),
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
    shape = function(cr, width, height)
        return gshape.pie(cr, width, height, -math.pi / 2, math.pi / 2)
    end,
    bg = beautiful.green,
    widget = wibox.container.background
}

return function(is_vertical)
    local battery_body = {
        {
            battery_bar,
            percentaje,
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
        {
            charge_icon,
            battery_body,
            layout = wibox.layout.fixed.horizontal
        },
        widget = wibox.container.place

    }

    local batt_last_value = 50
    local batt_low_value = 20
    local batt_critical_value = 15

    awesome.connect_signal(
        "signal::battery", function(value)
            battery_bar.value = value
            batt_last_value = value

            local color = beautiful.green
            if charge_icon.visible then
                color = beautiful.cyan

            elseif value <= batt_critical_value then
                color = beautiful.red
                if not charge_icon.visible then
                    notification {
                        text = "VERY low battery!",
                        urgency = "critical"
                    }
                end
            elseif value <= batt_low_value then
                color = beautiful.yellow
            end

            if color ~= nil then
                percentaje:set_markup_silently(helpers.colorize_text(value, color))
                positive_connection.bg = color
                battery_bar.color = color .. '70'
                battery_bar.background_color = color .. '10'
                battery_bar.border_color = color
            end
        end
    )

    awesome.connect_signal(
        "signal::charger", function(state)
            local color
            charge_icon.visible = state

            if state and color ~= nil then
                color = beautiful.cyan
                battery_widget:get_children_by_id('positive_connection')[1].bg = color
                battery_bar.color = color .. '70'
                battery_bar.background_color = color .. '10'
                battery_bar.border_color = color
            end
        end
    )

    battery_widget:buttons(
        -- Scrolling
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

    local container = {
        battery_widget,
        left = dpi(4),
        right = dpi(6),
        widget = wibox.container.margin
    }

    return container
end
