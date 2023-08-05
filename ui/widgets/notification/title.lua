local beautiful = require("beautiful")
local gstring = require("gears.string")
local naughty_widget = require("naughty.widget")
local wibox_container = require("wibox.container")
local wibox_widget = require("wibox.widget")

local function notif_title(args)
    local has_app_name = args.app_name and args.app_name ~= ""

    return wibox_widget {
        {
            markup = "<b>" .. gstring.xml_escape(args.title) .. "</b>" .. (
                has_app_name and " • " .. args.app_name or ""
            ),
            font = beautiful.font_name .. (args.size or " 11"),
            align = "left",
            valign = "center",
            widget = naughty_widget.title
        },
        step_function = wibox_container.scroll.step_functions.waiting_nonlinear_back_and_forth,
        speed = 40,
        forced_width = args.forced_width,
        widget = wibox_container.scroll.horizontal
    }
end

return notif_title
