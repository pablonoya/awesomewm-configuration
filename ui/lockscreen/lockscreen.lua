local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local naughty = require("naughty")
local wibox = require("wibox")

local helpers = require("helpers")
local color_helpers = require("helpers.color-helpers")

local lock_animation = require("ui.lockscreen.lock_animation")

local lock_screen = {}

local config_dir = gears.filesystem.get_configuration_dir()
package.cpath = package.cpath .. ";" .. config_dir .. "ui/lockscreen/lib/?.so;"
local pam = require("liblua_pam")

lock_screen.authenticate = function(password)
    return pam.auth_current_user(password)
end

-- Vars
local char =
    "I T L I S A S A M P M A C Q U A R T E R D C T W E N T Y F I V E X H A L F S T E N F T O P A S T E R U N I N E O N E S I X T H R E E F O U R F I V E T W O E I G H T E L E V E N S E V E N T W E L V E T E N S E O C L O C K"

local pos_map = {
    ["it"] = {1, 2},
    ["is"] = {4, 5},
    ["a"] = {12, 12},
    ["quarter"] = {14, 20},
    ["twenty"] = {23, 28},
    ["five"] = {29, 32},
    ["half"] = {34, 37},
    ["ten"] = {39, 41},
    ["past"] = {45, 48},
    ["to"] = {43, 44},
    ["1"] = {56, 58},
    ["2"] = {75, 77},
    ["3"] = {62, 66},
    ["4"] = {67, 70},
    ["5"] = {71, 74},
    ["6"] = {59, 61},
    ["7"] = {89, 93},
    ["8"] = {78, 82},
    ["9"] = {52, 55},
    ["10"] = {100, 102},
    ["11"] = {83, 88},
    ["12"] = {94, 99},
    ["oclock"] = {105, 110}
}

local char_map = {
    ["it"] = {},
    ["is"] = {},
    ["a"] = {},
    ["quarter"] = {},
    ["twenty"] = {},
    ["five"] = {},
    ["half"] = {},
    ["ten"] = {},
    ["past"] = {},
    ["to"] = {},
    ["1"] = {},
    ["2"] = {},
    ["3"] = {},
    ["4"] = {},
    ["5"] = {},
    ["6"] = {},
    ["7"] = {},
    ["8"] = {},
    ["9"] = {},
    ["10"] = {},
    ["11"] = {},
    ["12"] = {},
    ["oclock"] = {}
}

local reset_map = {
    4, 12, 14, 23, 29, 34, 39, 43, 45, 52, 56, 59, 62, 67, 71, 75, 78, 83, 89, 94, 100, 105
}

local function split_str(s, delimiter)
    local result = {}
    for match in (s .. delimiter):gmatch("(.-)" .. delimiter) do
        table.insert(result, match)
    end

    return result
end

local time_char = split_str(char, " ")

-- Helpers

local time = wibox.widget {
    forced_num_cols = 11,
    spacing = beautiful.useless_gap,
    layout = wibox.layout.grid
}

local function create_text_widget(index, w)
    local text_widget = wibox.widget {
        id = "t" .. index,
        markup = w,
        font = beautiful.font_name .. " Bold 18",
        align = "center",
        valign = "center",
        forced_width = dpi(25),
        forced_height = dpi(30),
        widget = wibox.widget.textbox
    }

    time:add(text_widget)

    return text_widget
end

local var_count = 0
for i, char in pairs(time_char) do
    local text = color_helpers.colorize_text(char, beautiful.light_black .. "16")

    var_count = var_count + 1
    local create_dummy_text = true

    for j, k in pairs(pos_map) do
        if i >= pos_map[j][1] and i <= pos_map[j][2] then
            char_map[j][var_count] = create_text_widget(i, text)
            create_dummy_text = false
        end

        for _, n in pairs(reset_map) do
            if i == n then
                var_count = 1
            end
        end

    end

    if create_dummy_text then
        create_text_widget(i, text)
    end

end

local last_hour
local last_minute
local time_of_day_color

local function activate_word(w)
    for i, char in pairs(char_map[w]) do
        char.markup = color_helpers.colorize_text(char.text, time_of_day_color)
    end
end

local function deactivate_word(w)
    for i, char in pairs(char_map[w]) do
        char.markup = color_helpers.colorize_text(char.text, beautiful.light_black .. "16")
    end
end

local function reset_time()
    for j, k in pairs(char_map) do
        deactivate_word(j)
    end

    activate_word("it")
    activate_word("is")
end

gears.timer {
    timeout = 2,
    call_now = true,
    autostart = true,
    callback = function()
        local time = os.date("%I:%M")
        local h, m = time:match("(%d+):(%d+)")
        local hour = tonumber(h)
        local min = tonumber(m)

        if last_hour ~= hour then
            time_of_day_color = color_helpers.get_color_by_time_of_day()
            last_hour = hour
        end

        -- update if minute has changed
        if last_minute == min then
            return
        end
        last_minute = min

        for s in screen do
            if s.lockscreen then
                s.lockscreen:get_children_by_id("container")[1].border_color = time_of_day_color
            end
        end

        reset_time()

        if min >= 0 and min <= 2 or min >= 58 and min <= 59 then
            activate_word("oclock")
        elseif min >= 3 and min <= 7 or min >= 53 and min <= 57 then
            activate_word("five")
        elseif min >= 8 and min <= 12 or min >= 48 and min <= 52 then
            activate_word("ten")
        elseif min >= 13 and min <= 17 or min >= 43 and min <= 47 then
            activate_word("a")
            activate_word("quarter")
        elseif min >= 18 and min <= 22 or min >= 38 and min <= 42 then
            activate_word("twenty")
        elseif min >= 23 and min <= 27 or min >= 33 and min <= 37 then
            activate_word("twenty")
            activate_word("five")
        elseif min >= 28 and min <= 32 then
            activate_word("half")
        end

        if min >= 3 and min <= 32 then
            activate_word("past")
        elseif min >= 33 and min <= 57 then
            activate_word("to")
        end

        local hh

        if min >= 0 and min <= 30 then
            hh = hour
        else
            hh = hour + 1
        end

        if hh > 12 then
            hh = hh - 12
        end

        activate_word(tostring(hh))
    end
}

local function set_visibility(visible)
    naughty.suspended = visible

    for s in screen do
        s.lockscreen.visible = visible
        s.lockscreen:get_children_by_id("container")[1].border_color = time_of_day_color
    end
end

-- Get input from user
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
            if lock_screen.authenticate(input) then
                lock_animation.reset()
                set_visibility(false)
            else
                lock_animation.fail()
                grab_password()
            end
        end,
        textbox = wibox.widget.textbox()
    }
end

function lock_screen_show()
    set_visibility(true)
    grab_password()
end

-- Add lockscreen to each screen
local lock_screen_box = function(s)
    return wibox {
        visible = false,
        ontop = true,
        type = "splash",
        screen = s,
        bg = beautiful.black .. "42"
    }
end

awful.screen.connect_for_each_screen(
    function(s)
        s.lockscreen = lock_screen_box(s)
        s.lockscreen:setup{
            {
                {
                    {
                        time,
                        lock_animation,
                        spacing = dpi(40),
                        layout = wibox.layout.fixed.vertical
                    },
                    margins = dpi(64),
                    widget = wibox.container.margin
                },
                id = "container",
                shape = helpers.rrect(beautiful.border_radius),
                bg = beautiful.xbackground,
                border_color = beautiful.focus,
                border_width = dpi(2),
                widget = wibox.container.background
            },
            widget = wibox.container.place
        }
    end
)

screen.connect_signal(
    "request::wallpaper", function(s)
        awful.placement.maximize(s.lockscreen)
    end
)
