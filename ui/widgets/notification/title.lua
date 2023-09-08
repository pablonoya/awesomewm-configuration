local beautiful = require("beautiful")
local gstring = require("gears.string")
local scroll = require("wibox.container.scroll")

local scrolling_text = require("ui.widgets.scrolling-text")

local function notif_title(args)
    local has_app_name = args.app_name and args.app_name ~= ""

    return scrolling_text {
        markup = "<b>" .. gstring.xml_escape(args.title) .. "</b>" ..
            gstring.xml_escape(has_app_name and " • " .. args.app_name or ""),
        font = beautiful.font_name .. (args.size or " 11"),
        step_function = scroll.step_functions.waiting_nonlinear_back_and_forth,
        speed = 40,
        forced_width = args.forced_width
    }
end

return notif_title
