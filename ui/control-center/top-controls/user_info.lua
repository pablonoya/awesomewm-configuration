local spawn = require("awful.spawn")
local beautiful = require("beautiful")
local gshape = require("gears.shape")
local gtimer = require("gears.timer")
local wibox = require("wibox")

local variables = require("configuration.variables")

local profile_pic = wibox.widget {
    id = "icon",
    image = variables.pfp,
    clip_shape = gshape.circle,
    scaling_quality = "best",
    widget = wibox.widget.imagebox
}

local profile_info = wibox.widget {
    font = beautiful.font_name .. "Semibold 12",
    markup = "user@hostname",
    halign = "left",
    valign = "center",
    widget = wibox.widget.textbox
}

local uptime = wibox.widget {
    font = beautiful.font_name .. "Medium 11",
    markup = "up 0 minutes",
    halign = "left",
    valign = "center",
    widget = wibox.widget.textbox
}

spawn.easy_async_with_shell(
    "echo $(whoami)@$(hostname)", function(stdout)
        profile_info:set_markup(stdout)
    end
)

local function set_uptime()
    spawn.easy_async_with_shell(
        "echo $(uptime -p)", function(stdout)
            uptime:set_markup(stdout)
        end
    )
end

local timer = gtimer {
    timeout = 30,
    call_now = true,
    callback = set_uptime
}

awesome.connect_signal(
    "control_center::visible", function(visible)
        if visible then
            set_uptime()
            timer:start()
        else
            timer:stop()
        end
    end
)

return wibox.widget {
    {
        profile_pic,
        {
            profile_info,
            uptime,
            layout = wibox.layout.fixed.vertical,
            forced_width = dpi(200)
        },
        layout = wibox.layout.fixed.horizontal,
        spacing = dpi(12)
    },
    valign = "center",
    widget = wibox.container.place
}
