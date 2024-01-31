local spawn = require("awful.spawn")
local beautiful = require("beautiful")
local gtimer = require("gears.timer")

local json = require("away.third_party.dkjson")

local endpoint = "https://api.openweathermap.org/data/2.5/weather"

local query_params = {
    appid = beautiful.weather_api_key,
    lat = beautiful.latitude,
    lon = beautiful.longitude,
    units = "metric",
    lang = "en"
}

local function table_to_query_string(query_params)
    local query_string = {}

    for key, value in pairs(query_params) do
        table.insert(query_string, string.format("%s=%s", key, value))
    end

    return table.concat(query_string, "&")
end

local function emit_weather_signal(stdout, stderr)
    awesome.emit_signal("weather::update", json.decode(stdout))
end

local function check_internet_connection(stdout, stderr)
    if stderr == "" then
        -- Internet connection is available
        local command = string.format(
            "curl -s -m 7 '%s?%s'", endpoint, table_to_query_string(query_params)
        )
        spawn.easy_async_with_shell(command, emit_weather_signal)
    else
        gtimer.delayed_call(check_internet_connection, 5)
    end
end

local timer = gtimer {
    timeout = 60 * 30,
    call_now = true,
    autostart = true,
    callback = function()
        spawn.easy_async_with_shell("ping -c 1 8.8.8.8", check_internet_connection)
    end
}
