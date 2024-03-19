local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")

local rubato = require("module.rubato")
local helpers = require("helpers")

local text_icon = require("ui.widgets.text-icon")

local popup_icon = text_icon {
    text = "\u{e050}",
    size = 40
}

local progressbar = wibox.widget {
    max_value = 100,
    background_color = beautiful.black,
    color = beautiful.accent,
    shape = gears.shape.rounded_bar,
    bar_shape = gears.shape.rounded_bar,
    border_width = dpi(2),
    border_color = beautiful.focus,
    paddings = dpi(6),
    forced_height = dpi(40),
    widget = wibox.widget.progressbar
}

local slide = rubato.timed {
    duration = 0.2,
    subscribed = function(val)
        progressbar:set_value(val)
    end
}

local function placement_fn(obj, args)
    awful.placement.top(
        obj, {
            margins = {
                top = dpi(80)
            }
        }
    )
end

local system_popup = awful.popup {
    widget = {
        {
            {
                popup_icon,
                {
                    progressbar,
                    widget = wibox.container.place
                },
                spacing = dpi(12),
                layout = wibox.layout.fixed.horizontal
            },
            widget = wibox.container.place
        },
        top = dpi(4),
        bottom = dpi(4),
        left = dpi(16),
        right = dpi(16),
        widget = wibox.container.margin
    },
    bg = beautiful.popup_bg,
    border_width = dpi(2),
    border_color = beautiful.focus,
    maximum_width = beautiful.popup_size,

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
    popup_icon.markup = icon_markup

    if value >= 0 then
        slide.target = value
        progressbar.color = color
        progressbar.border_color = color
        progressbar.visible = true
    else
        progressbar.visible = false
    end

    if self.visible then
        timer:again()
    else
        self.visible = true
        timer:start()
    end
end

return system_popup
