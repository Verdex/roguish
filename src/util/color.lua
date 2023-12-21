
local function values(self)
    return self.r, self.g, self.b, self.a
end

local function color(r, g, b, a)
    r = r or 0
    g = g or 0
    b = b or 0
    a = a or 1
    return { type = "color"
           , r = r
           , g = g
           , b = b
           , a = a
           , values = values 
           }
end