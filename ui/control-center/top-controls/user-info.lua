local spawn = require("awful.spawn")
local beautiful = require("beautiful")
local gshape = require("gears.shape")
local gtimer = require("gears.timer")
local wibox_container = require("wibox.container")
local wibox_layout = require("wibox.layout")
local wibox_widget = require("wibox.widget")

local profile_pic = wibox_widget {
    id = "icon",
    image = beautiful.pfp,
    clip_shape = gshape.circle,
    widget = wibox_widget.imagebox
}

local profile_info = wibox_widget {
    font = beautiful.font_name .. "Medium 12",
    markup = "user@hostname",
    align = "left",
    valign = "center",
    widget = wibox_widget.textbox
}

local uptime = wibox_widget {
    font = beautiful.font_name .. "Medium 11",
    markup = "up 0 minutes",
    align = "left",
    valign = "center",
    widget = wibox_widget.textbox
}

spawn.easy_async_with_shell(
    "echo $(whoami)@$(hostname)", function(stdout)
        profile_info:set_markup(stdout)
    end
)
gtimer {
    timeout = 60,
    call_now = true,
    autostart = true,
    callback = function()
        spawn.easy_async_with_shell(
            "echo $(uptime -p)", function(stdout)
                uptime:set_markup(stdout)
            end
        )
    end
}

local user_profile = wibox_widget {
    {
        profile_pic,
        {
            profile_info,
            uptime,
            layout = wibox_layout.fixed.vertical
        },
        layout = wibox_layout.fixed.horizontal,
        spacing = dpi(12)
    },
    valign = "center",
    widget = wibox_container.place
}

return user_profile
