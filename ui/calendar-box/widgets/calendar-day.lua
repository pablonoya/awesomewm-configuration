local beautiful = require("beautiful")
local gshape = require("gears.shape")
local wibox = require("wibox")

local focus_style = {
    bg = beautiful.accent,
    fg = beautiful.xbackground,
    shape = gshape.circle
}

return function(widget, flag, date)
    local style = {}
    if flag == "focus" then
        widget.markup = "<b>" .. widget.text .. "</b>"
        style = focus_style
    end

    local day = wibox.widget {
        {
            widget,
            halign = "center",
            valign = "center",
            forced_width = dpi(38),
            widget = wibox.container.place
        },
        shape = style.shape,
        fg = style.fg,
        bg = style.bg,
        widget = wibox.container.background
    }

    return day
end
