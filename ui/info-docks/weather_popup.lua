local beautiful = require("beautiful")
local wibox = require("wibox")

local color_helpers = require("helpers.color-helpers")
local border_popup = require("ui.widgets.border-popup")

-- Mapping from https://openweathermap.org/weather-conditions
local icon_map = {
    -- Clear
    ["01d"] = "\u{e81a}",
    ["01n"] = "\u{f159}",

    -- Few clouds
    ["02d"] = "\u{f172}",
    ["02n"] = "\u{f174}",

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

local function capitalize(s)
    return s:sub(1, 1):upper() .. s:sub(2)
end

local function format_description(description)
    local mapping = {
        ["overcast clouds"] = "Cloudy",
        ["broken clouds"] = "Mostly cloudy",
        ["scattered clouds"] = "Partly cloudy"
    }

    return mapping[description] or capitalize(description)
end

local function color_by_temp(text, temp)
    local color = beautiful.moon

    if temp < 10 then
        color = beautiful.blue
    elseif temp > 23 then
        color = beautiful.yellow
    elseif temp > 27 then
        color = beautiful.red
    end

    return color_helpers.colorize_text(text, color)
end

local function color_by_humidity(text, humidity)
    local color = beautiful.uranus

    if humidity > 27 then
        color = beautiful.cyan
    elseif humidity > 60 then
        color = beautiful.blue
    end

    return color_helpers.colorize_text(text, color)
end

local function color_by_wind_speed(text, speed)
    local color = beautiful.green
    if speed > 13.8 then
        color = beautiful.red
    elseif speed > 10.7 then
        color = beautiful.magenta
    elseif speed > 7.9 then
        color = beautiful.blue
    elseif speed > 3.3 then
        color = beautiful.cyan
    end

    return color_helpers.colorize_text(text, color)
end

local current_temp = wibox.widget {
    markup = "-°",
    font = beautiful.font_name .. "Medium 28",
    widget = wibox.widget.textbox
}

local icon = wibox.widget {
    markup = "\u{e2c1}",
    font = beautiful.icon_font_name .. 28,
    widget = wibox.widget.textbox
}

local feels_like = wibox.widget {
    markup = "Feels like -°",
    font = beautiful.font_name .. 12,
    widget = wibox.widget.textbox
}

local description = wibox.widget {
    markup = "Clear sky",
    font = beautiful.font_name .. "Medium 13",
    valign = "center",
    widget = wibox.widget.textbox
}

local humidity_icon = wibox.widget {
    markup = "\u{f164}",
    font = beautiful.icon_font_name .. 12,
    widget = wibox.widget.textbox
}

local humidity = wibox.widget {
    text = "-%",
    font = beautiful.font_name .. 12,
    widget = wibox.widget.textbox
}

local wind_icon = wibox.widget {
    markup = "\u{efd8}",
    font = beautiful.icon_font_name .. 12,
    widget = wibox.widget.textbox
}

local wind = wibox.widget {
    text = "- m/s",
    font = beautiful.font_name .. 12,
    widget = wibox.widget.textbox
}

local location_icon = wibox.widget {
    markup = "\u{e0c8}",
    font = beautiful.icon_font_name .. 12,
    widget = wibox.widget.textbox
}

local station = wibox.widget {
    markup = "Station",
    font = beautiful.font_name .. 12,
    widget = wibox.widget.textbox
}

local weather_popup = border_popup {
    widget = {
        {
            {
                {
                    {
                        current_temp,
                        icon,
                        spacing = dpi(4),
                        layout = wibox.layout.fixed.horizontal
                    },
                    feels_like,
                    halign = "center",
                    layout = wibox.layout.fixed.vertical
                },
                {
                    description,
                    {
                        {
                            humidity_icon,
                            humidity,
                            spacing = dpi(4),
                            layout = wibox.layout.fixed.horizontal
                        },
                        {
                            text = " • ",
                            widget = wibox.widget.textbox
                        },
                        {
                            wind_icon,
                            wind,
                            spacing = dpi(4),
                            layout = wibox.layout.fixed.horizontal
                        },
                        -- spacing = dpi(4),
                        layout = wibox.layout.fixed.horizontal
                    },
                    {
                        location_icon,
                        station,
                        spacing = dpi(4),
                        layout = wibox.layout.fixed.horizontal
                    },
                    spacing = dpi(4),
                    layout = wibox.layout.fixed.vertical
                },
                spacing = dpi(20),
                layout = wibox.layout.fixed.horizontal
            },
            top = dpi(8),
            bottom = dpi(8),
            left = dpi(12),
            right = dpi(12),
            widget = wibox.container.margin
        },
        forced_width = beautiful.notif_center_width,
        widget = wibox.container.background
    }
}

awesome.connect_signal(
    "weather::update", function(data)
        current_temp.markup = string.format(
            "%.0f%s", data.main.temp, color_by_temp("°", data.main.temp)
        )
        icon.markup = color_by_temp(icon_map[data.weather[1].icon], data.main.temp)
        feels_like.markup = string.format(
            "Feels like %.0f%s", data.main.feels_like, color_by_temp("°", data.main.feels_like)
        )

        description.markup = format_description(data.weather[1].description)
        humidity.markup = string.format(
            "%d%s", data.main.humidity, color_by_humidity("%", data.main.humidity)
        )
        wind.markup = string.format(
            "%.2f m%ss", data.wind.speed, color_by_wind_speed("/", data.wind.speed)
        )

        station.markup = string.format("%s, %s", data.name, data.sys.country)
    end
)

return weather_popup
