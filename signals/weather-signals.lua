local spawn = require("awful.spawn")
local beautiful = require("beautiful")
local gtimer = require("gears.timer")
local json = require("away.third_party.dkjson")

local endpoint = "https://api.openweathermap.org/data/2.5/weather"

local query_params = {
    appid = beautiful.weather_api_key,
    lat = beautiful.weather_latitude,
    lon = beautiful.weather_longitude,
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

local function emit_weather_signal()
    local cmd = string.format("curl -s -m 7 '%s?%s'", endpoint, table_to_query_string(query_params))
    spawn.easy_async_with_shell(
        cmd, function(stdout, stderr)
            local data = json.decode(stdout)

            awesome.emit_signal("weather::update", data)
        end
    )
end

local timer = gtimer {
    timeout = 60 * 10,
    call_now = true,
    autostart = true,
    callback = emit_weather_signal
}
