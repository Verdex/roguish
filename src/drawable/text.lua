
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
    if #self.texts > 0 then
        -- TODO:  this makes all of the lines nicely even, but it doesn't utilize all the space available
        -- at the end of the text box.
        -- Also when this is extended to use multiple texts then each one will have its own length which
        -- will probably look a bit strange.
        local tw = current_font:getWidth(self.texts[1]) 
        local th = current_font:getHeight(self.texts[1])
        local sections = math.floor((tw / w) + 1)
        local char_count = #self.texts[1]
        local prev = 1
        for i = 1, sections do
            local s = string.sub(self.texts[1], prev, (char_count / sections) * i)
            prev = ((char_count / sections) * i) + 1
            love.graphics.print(s, x + 1, y + (th * (i - 1)))
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

return { box = box }