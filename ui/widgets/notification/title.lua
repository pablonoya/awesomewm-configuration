local beautiful = require("beautiful")
local gstring = require("gears.string")

local scrolling_text = require("ui.widgets.scrolling-text")

local function format_notification_title(title, app_name)
    title = gstring.xml_unescape(title)

    if app_name and app_name ~= "" then
        app_name = gstring.xml_unescape(" • " .. app_name)
    else
        app_name = ""
    end

    return string.format("<b>%s</b>%s", title, app_name)
end

return function(args)
    return scrolling_text {
        markup = format_notification_title(args.title, args.app_name),
        font = beautiful.font_name .. (args.size or " 11"),
        speed = 40,
        forced_width = args.forced_width
    }
end
