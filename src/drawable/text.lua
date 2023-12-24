
local function draw_box(self) 
    local x = self.location.x
    local y = self.location.y
    local w = self.width
    local h = self.height

    local current_font = love.graphics.getFont()
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.polygon("fill", x, y, 
                                  x, y + w,
                                  x + h, y + w,
                                  x + h, y
                         )
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.polygon("line", x, y, 
                                  x, y + w,
                                  x + h, y + w,
                                  x + h, y
                         )
    local lowest_unused_row = y + h
    for i = #self.texts, 1, -1 do
        -- TODO:  this makes all of the lines nicely even, but it doesn't utilize all the space available
        -- at the end of the text box.
        -- Also when this is extended to use multiple texts then each one will have its own length which
        -- will probably look a bit strange.
        local tw = current_font:getWidth(self.texts[i]) 
        local th = current_font:getHeight(self.texts[i])
        local sections = math.floor((tw / w) + 1)
        local char_count = #self.texts[i]
        for sec = sections, 1, -1 do
            local str = string.sub(self.texts[i], ((char_count / sections) * (sec - 1)) + 1, (char_count / sections) * sec)
            lowest_unused_row = lowest_unused_row - th 
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