local beautiful = require("beautiful")
local wibox = require("wibox")

return function(widget)
    widget.markup = "<b>" .. widget.text:sub(1, 2) .. "</b>"

    return {
        {
            widget,
            halign = "center",
            widget = wibox.container.place
        },
        fg = beautiful.accent,
        widget = wibox.container.background
    }
end
