local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local naughty = require("naughty")
local wibox = require("wibox")

local helpers = require("helpers")
local color_helpers = require("helpers.color-helpers")

local lock_animation = require("ui.lockscreen.lock_animation")
local grab_password = require("ui.lockscreen.grab_password")

local INACTIVE_COLOR = beautiful.light_black .. 20

local CHARMAP =
    "I T L I S A S A M P M A I Q U A R T E R D C T W E N T Y F I V E X H A L F S T E N F T O P A S T E R U N I N E O N E S I X T H R E E F O U R F I V E T W O E I G H T E L E V E N S E V E N T W E L V E T E N S E O C L O C K"

local time_chars = gears.string.split(CHARMAP, " ")

local POS_MAP = {
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

local wordclock = wibox.widget {
    forced_num_cols = 11,
    spacing = dpi(4),
    layout = wibox.layout.grid
}

local char_widgets = {}
for pos, char in pairs(time_chars) do
    local text_widget = wibox.widget {
        markup = color_helpers.colorize_text(char, INACTIVE_COLOR),
        font = beautiful.font_name .. "Bold 18",
        halign = "center",
        valign = "center",
        forced_width = dpi(28),
        forced_height = dpi(32),
        widget = wibox.widget.textbox
    }

    char_widgets[pos] = text_widget
    wordclock:add(text_widget)
end

local last_hour
local last_minute
local active_color

local function colorize_word(word, color)
    local start, limit = table.unpack(POS_MAP[word])
    for pos = start, limit do
        char_widgets[pos].markup = color_helpers.colorize_text(char_widgets[pos].text, color)
    end
end

local function activate_word(word)
    colorize_word(word, active_color)
end

local function reset_clock()
    for word, _ in pairs(POS_MAP) do
        colorize_word(word, INACTIVE_COLOR)
    end

    activate_word("it")
    activate_word("is")
end

local lockscreen_body = wibox.widget {
    {
        {
            {
                wordclock,
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

local clock_timer = gears.timer {
    timeout = 2,
    call_now = true,
    callback = function()
        local time = os.date("%I:%M")
        local h, m = time:match("(%d+):(%d+)")
        local hour = tonumber(h)
        local min = tonumber(m)

        -- update only if time has changed
        if last_hour == hour and last_minute == min then
            return
        end

        if last_hour ~= hour then
            active_color = color_helpers.get_color_by_time_of_day()
            lockscreen_body:get_children_by_id("container")[1].border_color = active_color
        end

        reset_clock()
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

        local hh = (min >= 0 and min <= 30) and hour or (hour + 1)
        if hh > 12 then
            hh = hh - 12
        end

        activate_word(tostring(hh))

        last_hour = hour
        last_minute = min
    end
}

-- Add lockscreen to each screen
awful.screen.connect_for_each_screen(
    function(s)
        s.lockscreen = wibox {
            widget = lockscreen_body,
            visible = false,
            ontop = true,
            type = "splash",
            screen = s,
            bg = beautiful.black .. "42"
        }
    end
)

awesome.connect_signal(
    "lockscreen::visible", function(visible)
        if visible then
            grab_password()
            clock_timer:start()
        else
            clock_timer:stop()
        end

        naughty.suspended = visible
        for s in screen do
            s.lockscreen.visible = visible
            lockscreen_body:get_children_by_id("container")[1].border_color = active_color
        end
    end
)

screen.connect_signal(
    "request::wallpaper", function(s)
        awful.placement.maximize(s.lockscreen)
    end
)
