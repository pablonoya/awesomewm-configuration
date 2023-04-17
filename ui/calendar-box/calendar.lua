local awful_button = require("awful.button")
local beautiful = require("beautiful")
local gshape = require("gears.shape")
local gtable = require("gears.table")
local wibox = require("wibox")

local helpers = require("helpers")

-- calendar
local styles = {
    focus = {
        bg_color = beautiful.accent,
        fg_color = beautiful.xbackground,
        shape = gshape.circle,
        markup = function(t)
            return '<b>' .. t .. '</b>'
        end
    },

    header = {
        markup = function(t)
            return '<b>' .. t .. '</b>'
        end
    },

    weekday = {
        fg_color = beautiful.accent,
        markup = function(s)
            return '<b>' .. s:sub(1, 1):upper() .. "</b>"
        end
    }
}

local function icon_button(markup)
    local icon = wibox.widget(
        {
            {
                font = beautiful.icon_font_name .. ' 18',
                markup = markup,
                widget = wibox.widget.textbox
            },
            shape = gshape.circle,
            widget = wibox.widget.background
        }
    )

    icon:connect_signal(
        "mouse::enter", function()
            icon.bg = beautiful.focus
        end
    )

    icon:connect_signal(
        "mouse::leave", function()
            icon.bg = beautiful.transparent
        end
    )

    return icon
end

local button_previous = icon_button("<b>\u{e5cb}</b>")
local button_next = icon_button("<b>\u{e5cc}</b>")

local function decorate_cell(widget, flag, date)
    local props = styles[flag] or {}

    if props.markup and widget.get_text and widget.set_markup then
        widget:set_markup(props.markup(widget:get_text()))
    end

    if flag == "header" then
        return wibox.widget(
            {
                widget,
                nil,
                {
                    button_previous,
                    button_next,
                    layout = wibox.layout.fixed.horizontal
                },
                layout = wibox.layout.align.horizontal,
                widget = wibox.container.background
            }
        )
    end

    if flag == "weekday" then
        return wibox.widget(
            {
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
        )
    end

    return wibox.widget(
        {
            {
                widget,
                halign = "center",
                valign = "center",
                forced_width = (flag == "normal" or flag == "focus") and dpi(40) or nil,
                forced_height = (flag == "normal" or flag == "focus") and dpi(32) or nil,
                widget = wibox.container.place
            },
            shape = props.shape,
            fg = props.fg_color or beautiful.xforeground,
            bg = props.bg_color or beautiful.black,
            widget = wibox.container.background
        }
    )
end

local calendar = wibox.widget(
    {
        date = os.date("*t"),
        font = "Manrope 12",
        long_weekdays = true,
        fn_embed = decorate_cell,
        spacing = dpi(2),
        widget = wibox.widget.calendar.month
    }
)

local function change_date(date)
    local current_date = os.date("*t")
    date.day = (current_date.month == date.month) and current_date.day

    calendar:set_date(nil)
    calendar:set_date(date)
end

button_previous:buttons(
    gtable.join(
        awful_button(
            {}, 1, function()
                local date = calendar:get_date()
                date.month = date.month - 1
                change_date(date)
            end
        )
    )
)

button_next:buttons(
    gtable.join(
        awful_button(
            {}, 1, function()
                local date = calendar:get_date()
                date.month = date.month + 1
                change_date(date)
            end
        )
    )
)

local calendar_widget = wibox.widget(
    {
        {
            calendar,
            halign = "center",
            valign = "top",
            widget = wibox.container.place
        },
        top = dpi(4),
        bottom = dpi(8),
        widget = wibox.container.margin
    }
)

return calendar_widget
