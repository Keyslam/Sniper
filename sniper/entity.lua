local PATH = (...):gsub('%.[^%.]+$', '')

local Component = require(PATH..".component")
local System    = require(PATH..".system")

local Ffi = require("ffi")

local Entity = {
   openIDs = {},
   nextID  = 0,

   type = Ffi.typeof([[
      struct {
         int id;
         int mask;
      }
   ]])
}
Ffi.metatype(Entity.type, {__index = Entity})

function Entity.new()
   local entity = Ffi.new(Entity.type, Entity.nextID, 0)

   Entity.nextID = Entity.nextID + 1

   return entity
end

function Entity:give(component, ...)
   component.entities._data[self.id] = component.type(...)
   self.mask = self.mask + component.mask

   return self
end

function Entity:remove(component)
   Ffi.fill(component.entities._data + self.id, component.entities.__ct_size)
   self.mask = self.mask - component.mask

   return self
end

function Entity:destroy()
   for _, component in ipairs(Component.components) do
      Ffi.fill(component.entities._data + self.id, component.entities.__ct_size)
   end
end

function Entity:filter()
   for _, system in ipairs(System.systems) do
      if bit.band(self.mask, system.mask) == system.mask then
         system.entities[system.count] = self.id
         system.count = system.count + 1
      end
   end
end

return setmetatable(Entity, {
   __call = function(_, ...) return Entity.new(...) end,
})
