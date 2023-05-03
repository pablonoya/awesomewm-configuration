local beautiful = require("beautiful")

local helpers = {}

local color_map = {
    {0, 5, color = beautiful.late_night_color},
    {5, 8, color = beautiful.dawn_color},
    {12, 14, color = beautiful.midday_color},
    {8, 17, color = beautiful.morning_color},
    {17, 18, color = beautiful.dusk_color},
    {18, 24, color = beautiful.night_color},
}

function helpers.colorize_text(txt, fg)
    if fg == nil then
        fg = beautiful.xforeground
    end
    return "<span foreground='" .. fg .. "'>" .. txt .. "</span>"
end

function helpers.get_color_by_time_of_day()
    local hour = tonumber(os.date("%H"))

    for _, map in pairs(color_map) do
        if hour >= map[1] and hour < map[2] then
          return map.color
        end
      end
end

function helpers.colorize_by_time_of_day(text)
    local color = helpers.get_color_by_time_of_day()
    return helpers.colorize_text(text, color)
end

return helpers
