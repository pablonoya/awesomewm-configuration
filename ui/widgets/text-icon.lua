local beautiful = require "beautiful"
local wibox_widget = require "wibox.widget"

return function(args)
    return wibox_widget {
        markup = args.markup or args.text or "\u{e145}",
        font = beautiful.icon_font_name .. " " .. (args.size or 13),
        align = "center",
        valign = "center",
        ellipsize = "none",
        widget = wibox_widget.textbox
    }
end
