local PATH = (...):gsub('%.[^%.]+$', '')

local Array = require(PATH..".lds.array")
local Ffi = require("ffi")

local Component = {
   components = {},
   nextMask   = 1,
}

function Component.new(struct)
   local type     = Ffi.typeof("struct {"..struct.."}")
   local size     = Ffi.sizeof(type)
   local entities = Array.Array(type, 1000000)
   local mask     = Component.nextMask

   Component.nextMask = Component.nextMask * 2

   local component = {
      type     = type,
      size     = size,
      entities = entities,
      mask     = mask,
      empty    = type(),

      get = function(self, id)
         return self.entities:get(id)
      end
   }

   table.insert(Component.components, component)

   return component
end

return setmetatable(Component, {
   __call = function(_, ...) return Component.new(...) end,
})
