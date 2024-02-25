local beautiful = require("beautiful")

local _color = {}

local color_map = {
    {0, 5, color = beautiful.late_night_color},
    {5, 8, color = beautiful.dawn_color},
    {12, 14, color = beautiful.midday_color},
    {8, 18, color = beautiful.morning_color},
    {18, 19, color = beautiful.dusk_color},
    {19, 24, color = beautiful.night_color},
}

function _color.colorize_text(txt, fg)
    if fg == nil then
        fg = beautiful.xforeground
    end
    return "<span foreground='" .. fg .. "'>" .. txt .. "</span>"
end

function _color.get_color_by_time_of_day(hour)
    hour = tonumber(hour or os.date("%H"))

    for _, map in pairs(color_map) do
        if hour >= map[1] and hour < map[2] then
            return map.color
        end
    end
end

function _color.colorize_by_time_of_day(text)
    local target_color = _color.get_color_by_time_of_day()
    return _color.colorize_text(text, target_color)
end

return _color
