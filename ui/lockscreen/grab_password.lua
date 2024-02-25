local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")

local config_dir = gears.filesystem.get_configuration_dir()
package.cpath = package.cpath .. ";" .. config_dir .. "ui/lockscreen/lib/?.so;"
local pam = require("liblua_pam")

local lock_animation = require("ui.lockscreen.lock_animation")

local function grab_password()
    local function reset_input()
        lock_animation.reset()
        grab_password()
    end

    awful.prompt.run {
        hooks = {
            -- Do not cancel input with Escape or Ctrl+Del
            -- This will just clear any input received so far.
            {{}, "Escape", reset_input}, {{"Control"}, "Delete", reset_input},

            -- Prevent Awesomewm restarting
            {{"Control", "Mod4"}, "r", reset_input}
        },

        keypressed_callback = function(mod, key, cmd)
            -- Only count single character keys (thus preventing
            -- "Shift", "Escape", etc from triggering the animation)
            if #key == 1 then
                lock_animation.key_animation("insert")
            elseif key == "BackSpace" then
                lock_animation.key_animation("remove")
            end
        end,

        exe_callback = function(input)
            -- Check input
            if pam.auth_current_user(input) then
                lock_animation.reset()
                awesome.emit_signal("lockscreen::visible", false)
            else
                lock_animation.fail()
                grab_password()
            end
        end,

        textbox = wibox.widget.textbox()
    }
end

return grab_password
