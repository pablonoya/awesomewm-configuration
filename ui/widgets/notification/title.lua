local beautiful = require("beautiful")
local gstring = require("gears.string")

local scrolling_text = require("ui.widgets.scrolling-text")

local function elapsed_time(creation_time)
    local time_diff = os.time() - creation_time

    if time_diff < 60 then
        return os.date("%I:%M", creation_time)
    elseif time_diff < 3600 then
        return string.format("%dm", time_diff // 60)
    elseif time_diff < 3600 * 12 then
        return string.format("%dh", time_diff // 3600)
    else
        return os.date("%d/%m", creation_time)
    end
end

local function format_notification_title(title, app_name, created_at)
    title = gstring.xml_escape(title)

    if app_name and app_name ~= "" then
        app_name = gstring.xml_escape(" • " .. app_name)
    else
        app_name = ""
    end

    return string.format("<b>%s</b>%s • %s", title, app_name, elapsed_time(created_at))
end

return function(args)
    local title = scrolling_text {
        markup = format_notification_title(
            args.notification.title, args.notification.app_name, args.notification.creation_time
        ),
        font = beautiful.font_name .. (args.size or " 11"),
        speed = 40,
        forced_width = args.forced_width
    }

    args.notification:connect_signal(
        "property::title", function()
            title.text.markup = format_notification_title(
                args.notification.title, args.notification.app_name, args.notification.creation_time
            )
        end
    )

    return title
end
