
local vec = require "util/vec"

local function manager_add_particle(self, particle)
    assert(type(particle) == "table" and particle.type == "particle")

    local t = self.particles[particle.owner_id]
    if t then
        t[#t+1] = particle
    else
        self.particles[particle.owner_id] = { particle }
    end
end

local function manager_delete_particles(self, owner_id)
    self.particles[owner_id] = nil
end

local function manager_update(self, delta) -- TODO collision
    for _, p_list in pairs(self.particles) do 
        local remove = {}
        for i, p in ipairs(p_list) do
            local _, r, g, b, a = p.color_path(delta)
            local incomplete, x, y = p.vec_path(delta)
            p.r = r
            p.g = g 
            p.b = b
            p.a = a
            p.location.x = x
            p.location.y = y
            if not incomplete then
                remove[#remove+1] = i
            end
        end
        for _, r in ipairs(remove) do
            table.remove(p_list, r)
        end
    end
end

local function manager_draw(self) -- TODO virtual space to screen space transform
    for _, p_list in pairs(self.particles) do 
        for _, p in ipairs(p_list) do
            love.graphics.setColor(p.r, p.g, p.b, p.a)
            p.drawer(p.location)
        end
    end
end

local function manager()
    return { type = "particle_manager"
           , particles = {}
           , add = manager_add_particle
           , update = manager_update
           , draw = manager_draw
           }
end

local function particle(owner_id, drawer, vec_path, color_path)
    assert(type(owner_id) == "table")
    assert(type(drawer) == "function")
    assert(type(vec_path) == "function")
    assert(type(color_path) == "function")

    local _, x, y = vec_path(0)
    local _, r, g, b, a = color_path(0)

    return { type = "particle"
           , owner_id = owner_id
           , location = vec.vec2(x, y)
           , vec_path = vec_path
           , r = r
           , g = g
           , b = b
           , a = a
           , color_path = color_path
           , drawer = drawer
           }
end

local function pixel_drawer(v)
    love.graphics.points(v.x, v.y)
end

return { manager = manager 
       , particle = particle
       , pixel_drawer = pixel_drawer
       }