local helpers = {}

function helpers.get_volume_icon(value)
    if value >= 5 and value < 50 then
        return "\u{e04d}"
    elseif value >= 50 then
        return "\u{e050}"
    end
    return "\u{e04e}"
end

function helpers.get_brightness_icon(value)
    if value >= 25 and value < 50 then
        return "\u{e3a9}"
    elseif value >= 50 and value < 75 then
        return "\u{e1ae}"
    elseif value >= 75 then
        return "\u{e1ac}"
    end
    return "\u{e1ad}"
end

return helpers
