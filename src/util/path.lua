
local function color_path(start_color, end_color, duration)
    assert(type(start_color) == "table" and start_color.type == "color")
    assert(type(end_color) == "table" and end_color.type == "color")
    assert(type(duration) == "number")

    local sr = start_color.r
    local sg = start_color.g
    local sb = start_color.b
    local sa = start_color.a

    local r = end_color.r - sr
    local g = end_color.g - sg
    local b = end_color.b - sb
    local a = end_color.a - sa

    local total_elapsed = 0

    return function (delta) 
        -- NOTE:  No table access.  Do not reference start or end color.
        total_elapsed = total_elapsed + delta
        if total_elapsed <= duration then
            local i = total_elapsed / duration
            return true, sr + (r * i), sg + (g * i), sb + (b * i), sa + (a * i)
        else
            return false, sr + r, sg + g, sb + b, sa + a
        end
    end
end

return { color = color_path }