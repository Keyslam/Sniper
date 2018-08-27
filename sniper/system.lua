local Ffi = require("ffi")

local System = {
   systems = {}
}

function System.new(filter)
   local mask     = 0
   local entities = Ffi.new("int[?]", 1000000)
   local count    = 0

   for _, component in ipairs(filter) do
      mask = mask + component.mask
   end

   local system = {
      mask     = mask,
      entities = entities,
      count    = count,

      get = function(self, id)
         return self.entities[id - 1]
      end,
   }

   table.insert(System.systems, system)

   return system
end

return setmetatable(System, {
   __call = function(_, ...) return System.new(...) end,
})
