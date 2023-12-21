local vec = require "util/vec"
local color = require "util/color"
local path = require "util/path"

-- this only gets called once at the beginning
function love.load()
    triangles = {}
    m_up = 0
    m_right = 0
    location = {x = 0, y = 0}
end


-- this function is called continuously
-- dt is the delta time (in seconds) of the last
-- time that the function was called
function love.update(dt)
    local px = dt * m_right
    local py = dt * m_up

    location.x = location.x + px
    location.y = location.y + py

    for _, triangle in ipairs(triangles) do
        triangle.x = triangle.x + (10 * dt) 
        triangle.y = triangle.y + (10 * dt)
    end

    c, r, g, b, a = p(dt)
end

function angle(v1, v2) 
    return math.acos(v1:dot(v2) / (v1:mag() * v2:mag()))
end

s = color.color(1, 0, 0, 1)
e = color.color(0, 0, 1, 1)
p = path.color(s, e, 10)
c, r, g, b, a = true, s:values()

-- this is the only function that the graphics functions
-- will work in
function love.draw()
    love.graphics.clear()
    love.graphics.setColor(r, g, b, a)

    for i = 1, #triangles - (#triangles % 3), 3 do
        love.graphics.polygon("fill", triangles[i].x, triangles[i].y, triangles[i+1].x, triangles[i+1].y, triangles[i+2].x, triangles[i+2].y)
    end

    local inside = false
    for i = 1, #triangles - (#triangles % 3), 3 do
        local x1 = triangles[i].x
        local y1 = triangles[i].y
        local x2 = triangles[i+1].x
        local y2 = triangles[i+1].y
        local x3 = triangles[i+2].x
        local y3 = triangles[i+2].y

        local v1 = vec.vec2(x1, y1)
        local v2 = vec.vec2(x2, y2)
        local v3 = vec.vec2(x3, y3)

        local tx = location.x
        local ty = location.y

        v1:add_raw(-tx, -ty)
        v2:add_raw(-tx, -ty)
        v3:add_raw(-tx, -ty)

        if math.abs(angle(v1, v2) + angle(v1, v3) + angle(v2, v3) - (math.pi * 2)) < 0.0001 then
            inside = true
            break
        end
    end

    if inside then
        love.graphics.setColor(0, 0, 1, 1)
    else 
        love.graphics.setColor(1, 0, 0, 1)
    end
    love.graphics.print("@", location.x, location.y)

end

function love.mousepressed(x, y, button, istouch)
    triangles[#triangles+1] = { x = x, y = y }
end

function love.mousereleased(x, y, button, istouch)

end

function love.keypressed(key)
    local m = 60
    if key == "right" then
        m_right = m_right + m
    elseif key == "left" then
        m_right = m_right - m
    elseif key == "up" then
        m_up = m_up - m
    elseif key == "down" then
        m_up = m_up + m
    end
end

function love.keyreleased(key)
    local m = 60
    if key == "right" then
        m_right = m_right - m
    elseif key == "left" then
        m_right = m_right + m 
    elseif key == "up" then
        m_up = m_up + m
    elseif key == "down" then
        m_up = m_up - m 
    end
end

function love.gamepadpressed(joystick, button)
end

function love.gamepadreleased(joystick, button)
end

function love.focus(in_focus)
end

function love.quit()
end