
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

local function manager()
    return { type = "particle_manager"
           , particles = {}
           , add = manager_add_particle
           }
end

local function particle(owner_id, vec_path, color)
    assert(type(owner_id) == "table")
    assert(type(vec_path) == "function")
    assert(color) 

    return { type = "particle"
           , owner_id = owner_id
           , vec_path = vec_path
           , color = color
           }
end

return { manager = manager 
       , particle = particle
       }