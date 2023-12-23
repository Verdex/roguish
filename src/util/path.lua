
local vec = require "util/vec"
-- TODO i, x, y -> x', y' functions (i = 0: x, y = x, y and i = 1: x, y = x, y)

local function linear_ease_to_mod(i)
    if i < 0.5 then
        return 2 * i
    else
        return (-2 * i) + 2
    end
end

local function mod_counter_spin(radius)
    return function(i, x, y)
        local m = linear_ease_to_mod(i) * radius
        local xish = m * math.sin(i * math.pi * 2) 
        local yish = m * math.cos(i * math.pi * 2) 
        return  xish + x, yish + y
    end
end

local function mod_clockwise_spin(radius)
    return function(i, x, y)
        local m = linear_ease_to_mod(i) * radius
        local xish = m * math.cos(i * math.pi * 2) 
        local yish = m * math.sin(i * math.pi * 2) 
        return  xish + x, yish + y
    end
end

local function vec_path(start_vec, end_vec, duration, mod)
    assert(type(start_vec) == "table" and start_vec.type == "vec2")
    assert(type(end_vec) == "table" and end_vec.type == "vec2")
    assert(type(duration) == "number")

    local sx = start_vec.x
    local sy = start_vec.y

    local x = end_vec.x - sx
    local y = end_vec.y - sy

    local total_elapsed = 0

    if mod then
        assert(type(mod) == "function")
        return function (delta) 
            -- NOTE:  No table access.  Do not reference start or end vec.
            total_elapsed = total_elapsed + delta
            if total_elapsed <= duration then
                local i = total_elapsed / duration
                return true, mod(i, sx + (x * i), sy + (y * i))
            else
                return false, sx + x, sy + y 
            end
        end
    else
        return function (delta) 
            -- NOTE:  No table access.  Do not reference start or end vec.
            total_elapsed = total_elapsed + delta
            if total_elapsed <= duration then
                local i = total_elapsed / duration
                return true, sx + (x * i), sy + (y * i)
            else
                return false, sx + x, sy + y 
            end
        end
    end
end

local function split_vec(start_vec, end_vec, count)
    assert(type(start_vec) == "table" and start_vec.type == "vec2")
    assert(type(end_vec) == "table" and end_vec.type == "vec2")
    assert(type(count) == "number")

    local x = end_vec.x - start_vec.x
    local y = end_vec.y - start_vec.y

    local ret = {}
    for i = 1, count do
        local s = vec.vec2(x, y):scale((i - 1) / count):add(start_vec)
        local e = vec.vec2(x, y):scale(i / count):add(start_vec)
        ret[#ret+1] = { start_vec = s, end_vec = e }
    end

    return ret
end

local function combine_vec(...)
    local paths = {...}
    assert(#paths > 1)

    local i = 1

    return function (delta)
        local incomplete, x, y = paths[i](delta)
        if not incomplete and i >= #paths then
            return false, x, y
        elseif not incomplete and i < #paths then
            i = i + 1
            return true, x, y
        else 
            return true, x, y
        end
    end
end

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

    return function (delta, set_total_elapsed) 
        -- NOTE:  No table access.  Do not reference start or end color.
        total_elapsed = set_total_elapsed or (total_elapsed + delta)
        if total_elapsed <= duration then
            local i = total_elapsed / duration
            return true, sr + (r * i), sg + (g * i), sb + (b * i), sa + (a * i)
        else
            return false, sr + r, sg + g, sb + b, sa + a
        end
    end
end

local function cycle_color( ...)
    local paths = {...}
    assert(#paths > 1)

    local i = 1

    return function (delta, set_total_elapsed)
        local incomplete, r, g, b, a = paths[i](delta, set_total_elapsed)
        if not incomplete and i >= #paths then
            i = 1
            for _, path in ipairs(paths) do
                path(0, 0)
            end
            return true, r, g, b, a 
        elseif not incomplete and i < #paths then
            i = i + 1
            return true, r, g, b, a
        else 
            return true, r, g, b, a
        end
    end
end

local function combine_color(...)
    local paths = {...}
    assert(#paths > 1)

    local i = 1

    return function (delta, set_total_elapsed)
        local incomplete, r, g, b, a = paths[i](delta, set_total_elapsed)
        if not incomplete and i >= #paths then
            return false, r, g, b, a
        elseif not incomplete and i < #paths then
            i = i + 1
            return true, r, g, b, a
        else 
            return true, r, g, b, a
        end
    end
end

return { color = color_path
       , combine_color = combine_color 
       , cycle_color = cycle_color
       , vec = vec_path
       , combine_vec = combine_vec
       , split_vec = split_vec
       , mod_clockwise_spin = mod_clockwise_spin
       , mod_counter_spin = mod_counter_spin
       }