local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")

local rubato = require("module.rubato")
local helpers = require("helpers")

local text_icon = require("ui.widgets.text-icon")

local function placement_fn(obj, args)
    awful.placement.top(
        obj, {
            margins = {
                top = dpi(64)
            }
        }
    )
end

local font_icon = text_icon {
    text = "\u{e050}",
    size = 24,
    fill = 0
}

font_icon.point = {}

local icon = wibox.layout {
    forced_width = dpi(28),
    forced_height = dpi(32),
    layout = wibox.layout.manual
}

icon:add(font_icon)

local progressbar = wibox.widget {
    max_value = 120,
    background_color = beautiful.xbackground,
    shape = gears.shape.rounded_bar,
    bar_shape = gears.shape.rounded_bar,
    border_color = beautiful.focus,
    forced_height = dpi(32),
    widget = wibox.widget.progressbar
}

local slide = rubato.timed {
    duration = 0.2,
    subscribed = function(val)
        progressbar:set_value(val + 20)
        icon:move_widget(
            font_icon, {
                x = val * 1.6,
                y = 0
            }
        )
    end
}

local bordered_progressbar = wibox.widget {
    {
        progressbar,
        icon,
        spacing = dpi(6),
        layout = wibox.layout.stack
    },
    shape = gears.shape.rounded_bar,
    border_width = dpi(1.6),
    widget = wibox.container.background
}

local system_popup = awful.popup {
    widget = {
        bordered_progressbar,

        top = dpi(12),
        bottom = dpi(12),
        left = dpi(16),
        right = dpi(16),
        shape = gears.shape.rounded_bar,
        widget = wibox.container.margin
    },
    clip_shape = gears.shape.rounded_bar,
    shape_bounding = gears.shape.rounded_bar,

    bg = beautiful.popup_bg,
    border_width = dpi(2),
    border_color = beautiful.focus,
    maximum_width = beautiful.popup_size,
    shape = helpers.rrect(beautiful.border_radius),
    placement = placement_fn,
    ontop = true,
    visible = false
}

local timer = gears.timer {
    timeout = 1.6,
    single_shot = true,
    callback = function()
        system_popup.visible = false
    end
}

function system_popup:show(icon_markup, value, color)
    self.screen = awful.screen.focused()
    font_icon.markup = icon_markup

    if value >= 0 then
        slide.target = value

        progressbar.color = color
        progressbar.background_color = color .. "28"

        bordered_progressbar.border_color = color
        progressbar.visible = true
    else
        progressbar.visible = false
        bordered_progressbar.border_color = beautiful.black

        icon:move_widget(
            font_icon, {
                y = 0,
                x = 0
            }
        )
    end

    if self.visible then
        timer:again()
    else
        self.visible = true
        timer:start()
    end
end

return system_popup
