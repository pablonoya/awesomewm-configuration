local beautiful = require("beautiful")
local wibox = require("wibox")

local color_helpers = require("helpers.color-helpers")

-- Mapping from https://openweathermap.org/weather-conditions
local icon_map = {
    -- Clear
    ["01d"] = '\u{e81a}',
    ["01n"] = "\u{f159}",

    -- Few clouds
    ["02d"] = '\u{f172}',
    ["02n"] = '\u{f174}',

    -- Partly cloudy
    ["03d"] = "\u{f172}",
    ["03n"] = "\u{f174}",

    ["04d"] = "\u{f172}",
    ["04n"] = "\u{f174}",

    -- Rain
    ["09d"] = "\u{f176}",
    ["09n"] = "\u{f176}",

    ["10d"] = "\u{f176}",
    ["10n"] = "\u{f176}",

    -- Thunderstorm
    ["11d"] = "\u{f61e}",
    ["11n"] = "\u{f61e}",

    -- Snow
    ["13d"] = "\u{e810}",
    ["13n"] = "\u{e810}",

    -- Mist
    ["50d"] = "\u{e818}",
    ["50n"] = "\u{e818}"
}

local function get_description(description)
    local mapping = {
        ["clear sky"] = "Clear",
        ["overcast clouds"] = "Cloudy",
        ["broken clouds"] = "Mostly cloudy",
        ["scattered clouds"] = "Partly cloudy"
    }

    local function capitalize(s)
        return s:sub(1, 1):upper() .. s:sub(2)
    end

    return mapping[description] or capitalize(description)
end

local station = wibox.widget {
    markup = "Station",
    font = beautiful.font_name .. "12",
    widget = wibox.widget.textbox
}

local current_temp = wibox.widget {
    markup = "-- °C",
    font = beautiful.font_name .. "Semibold 32",
    widget = wibox.widget.textbox
}

local feels_like = wibox.widget {
    markup = "Feels like - °C",
    font = beautiful.font_name .. "Medium 12",
    widget = wibox.widget.textbox
}

local icon = wibox.widget {
    markup = "\u{e2c1}",
    font = beautiful.icon_font_name .. "50 @FILL=1",
    valign = "center",
    halign = "center",
    widget = wibox.widget.textbox
}

local description = wibox.widget {
    markup = "Clear",
    halign = "center",
    font = beautiful.font_name .. "Medium 12",
    widget = wibox.widget.textbox
}

local weather = wibox.widget {
    {
        {
            {
                station,
                current_temp,
                feels_like,
                layout = wibox.layout.fixed.vertical
            },
            nil,
            {
                icon,
                description,
                layout = wibox.layout.fixed.vertical
            },
            spacing = dpi(20),
            layout = wibox.layout.align.horizontal
        },
        margins = dpi(16),
        widget = wibox.container.margin
    },
    forced_width = dpi(320),
    widget = wibox.container.background
}

awesome.connect_signal(
    "weather::update", function(data)
        station.markup = string.format("%s, %s", data.name, data.sys.country)

        current_temp.markup = string.format("%.0f °C", data.main.temp)
        feels_like.markup = string.format("Feels like %.0f °C", data.main.feels_like)

        icon.markup = color_helpers.colorize_by_time_of_day(icon_map[data.weather[1].icon])
        description.markup = get_description(data.weather[1].description)
    end
)

return weather
