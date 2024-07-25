local beautiful = require("beautiful")

local _helpers = {}

function _helpers.get_volume_icon(value)
    if value >= 5 and value < 50 then
        return "\u{e04d}"
    elseif value >= 50 then
        return "\u{e050}"
    end
    return "\u{e04e}"
end

function _helpers.get_brightness_icon(value)
    if value >= 25 and value < 50 then
        return "\u{e1ae}"
    elseif value >= 50 and value < 75 then
        return "\u{e3a9}"
    elseif value >= 75 then
        return "\u{e1ac}"
    end
    return "\u{e1ad}"
end

function _helpers.toggle_filled_icon(icon, size, filled)
    icon.font = beautiful.icon_font_name .. size .. " @FILL=" .. (filled and 1 or 0)
end

return _helpers
