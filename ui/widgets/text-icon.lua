local beautiful = require "beautiful"
local wibox_widget = require "wibox.widget"

return function(args)
    return wibox_widget {
        markup = args.markup or args.text or "\u{e145}",
        font = beautiful.icon_font_name .. (args.size or 13) .. " @FILL=1",
        halign = "center",
        valign = "center",
        ellipsize = "none",
        visible = args.visible,
        widget = wibox_widget.textbox
    }
end
