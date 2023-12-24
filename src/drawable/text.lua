
local function draw_box(self) 
    local current_font = love.graphics.getFont()
    local th = current_font:getHeight()

    local x = self.location.x 
    local y = self.location.y
    local w = self.width
    local h = self.height

    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.polygon("fill", x, y, 
                                  x, y + h,
                                  x + w, y + h,
                                  x + w, y 
                         )
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.polygon("line", x, y, 
                                  x, y + h,
                                  x + w, y + h,
                                  x + w, y 
                         )
    love.graphics.line(x, y + th, x + w, y + th)
    
    y = self.location.y + th
    h = self.height - th

    local lowest_unused_row = y + h
    for i = #self.texts, 1, -1 do
        -- NOTE:  This is making sure all lines are the same length.  The end result is that there is typically
        -- un-utilized right space.
        local tw = current_font:getWidth(self.texts[i]) 
        local sections = math.floor((tw / w) + 1)
        local char_count = #self.texts[i]
        for sec = sections, 1, -1 do
            lowest_unused_row = lowest_unused_row - th 
            if lowest_unused_row < y then
                break
            end
            local str = string.sub(self.texts[i], ((char_count / sections) * (sec - 1)) + 1, (char_count / sections) * sec)
            love.graphics.print(str, x + 1, lowest_unused_row)
        end
    end
end

local function add_text_box(self, text)
    self.texts[#self.texts + 1] = text
end

local function box(location, height, width, texts)
    assert(type(location) == "table" and location.type == "vec2")
    assert(type(height) == "number")
    assert(type(width) == "number")

    return { type = "box"
           , location = location
           , texts = texts or {} 
           , height = height
           , width = width
           , draw = draw_box
           , add_text = add_text_box
           }
end

--[[
local function console(location, height, width)
    assert(type(location) == "table" and location.type == "vec2")
    assert(type(height) == "number")
    assert(type(width) == "number")

    return { type = "console"
           , box = box(location, height, width)
           }
end
--]]

return { box = box }