local awful_button = require("awful.button")
local beautiful = require("beautiful")
local gshape = require("gears.shape")
local gtable = require("gears.table")
local wibox = require("wibox")

local helpers = require("helpers")
local border_container = require("ui.widgets.border-container")
local clickable_container = require("ui.widgets.clickable-container")
local text_icon = require("ui.widgets.text-icon")

local function capitalize(s)
    return s:sub(1, 1):upper() .. s:sub(2)
end

local styles = {
    focus = {
        bg_color = beautiful.accent,
        fg_color = beautiful.xbackground,
        shape = gshape.circle,
        style_markup = function(t)
            return '<b>' .. t .. '</b>'
        end
    },

    header = {
        style_markup = function(t)
            return '<b>' .. capitalize(t) .. '</b>'
        end
    },

    weekday = {
        fg_color = beautiful.accent,
        style_markup = function(t)
            return '<b>' .. t:sub(1, 2) .. "</b>"
        end
    }
}

local function icon_button(markup)
    return clickable_container {
        widget = text_icon {
            markup = markup,
            size = 18
        },
        shape = gshape.circle
    }
end

local button_previous = icon_button("\u{e5cb}")
local button_next = icon_button("\u{e5cc}")
local button_today = border_container {
    widget = clickable_container {
        widget = wibox.widget {
            markup = "today",
            valign = "center",
            font = beautiful.font_name .. 11,
            widget = wibox.widget.textbox
        },
        margins = {
            left = dpi(4),
            right = dpi(4)
        },
        shape = helpers.rrect(beautiful.border_radius / 2)
    },
    shape = helpers.rrect(beautiful.border_radius / 2)
}

local function decorate_cell(widget, flag, date)
    local props = styles[flag] or {}

    if props.style_markup and widget.set_markup and widget.text then
        widget:set_markup(props.style_markup(widget.text))
    end

    if flag == "header" then
        return {
            {
                button_previous,
                button_next,
                layout = wibox.layout.fixed.horizontal
            },
            widget,
            button_today,
            layout = wibox.layout.align.horizontal
        }

    elseif flag == "weekday" then
        return {
            {
                widget,
                halign = "center",
                forced_width = dpi(36),
                widget = wibox.container.place
            },
            fg = props.fg_color or beautiful.xforeground,
            bg = props.bg_color or beautiful.black,
            widget = wibox.container.background
        }

    elseif flag == "normal" or flag == "focus" then
        return {
            {
                widget,
                halign = "center",
                valign = "center",
                forced_width = dpi(40),
                forced_height = dpi(32),
                widget = wibox.container.place
            },
            shape = props.shape,
            fg = props.fg_color or beautiful.xforeground,
            bg = props.bg_color or beautiful.black,
            widget = wibox.container.background
        }
    end

    return widget
end

local calendar = wibox.widget {
    date = os.date("*t"),
    font = "Manrope 12",
    long_weekdays = true,
    fn_embed = decorate_cell,
    spacing = dpi(2),
    widget = wibox.widget.calendar.month
}

local function change_date(date)
    local current_date = os.date("*t")
    date.day = (current_date.month == date.month) and current_date.day

    calendar:set_date(nil)
    calendar:set_date(date)
end

local function previous_month()
    local date = calendar:get_date()
    date.month = date.month - 1
    change_date(date)
end

local function next_month()
    local date = calendar:get_date()
    date.month = date.month + 1
    change_date(date)
end

helpers.add_action(button_previous, previous_month)
helpers.add_action(button_next, next_month)
helpers.add_action(
    button_today, function()
        change_date(os.date("*t"))
    end
)

local calendar_widget = wibox.widget {
    {
        calendar,
        halign = "center",
        valign = "top",
        widget = wibox.container.place
    },
    top = dpi(6),
    bottom = dpi(8),
    widget = wibox.container.margin
}

return calendar_widget
