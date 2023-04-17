local beautiful = require "beautiful"
local wibox_widget = require "wibox.widget"

return function(args)
    return wibox_widget {
        text = args.text or "-",
        font = beautiful.font_name .. "Medium 12",
        valign = "center",
        halign = "right",
        forced_width = dpi(44),
        widget = wibox_widget.textbox
    }
end
