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

      added = Ffi.new("int[?]", 1000000),
      addN  = 0,

      removed = Ffi.new("bool[?]", 1000000),
      removeN = 0,

      add = function(self, id)
         local i = self.addN - 1

         for j = self.addN, 0, -1 do
            if i < 0 or id > self.added[i] then
               self.added[j] = id
               break
            end

            self.added[j] = self.added[i]
            i = i - 1
         end

         self.addN = self.addN + 1
      end,

      remove = function(self, id)
         self.removed[id] = true
         self.removeN = self.removeN + 1
      end,

      flush = function(self)
         if self.removeN > 0 then
            local len  = self.count
            local left = len

            local j = 0
            for i = 0, len - 1 do
               local e = self.entities[i]
               if self.removed[e] then
                  self.removed[e] = false
                  left = left - 1
               else
                  self.entities[j] = self.entities[i]
                  j = j + 1
               end
            end

            --[[
            for i = left + 1, len do
               self.entities[i] = 0
            end
            ]]
         end

         self.count = self.count - self.removeN

         if self.addN > 0 then
            local eI = self.count - 1
            local aI = self.addN - 1

            for i = self.count + self.addN - 1, 0, -1 do
               local id  = self.entities[eI]
               local aId = self.added[aI]

               if eI < 0 or aId > id then
                  self.entities[i] = aId
                  self.added[aI] = 0
                  aI = aI - 1
               else
                  self.entities[i] = id

                  eI = eI - 1
               end
            end
         end

         self.count = self.count + self.addN

         self.addN  = 0
         self.removeN = 0
      end,

      get = function(self, i)
         return self.entities[i]
      end,
   }

   table.insert(System.systems, system)

   return system
end

return setmetatable(System, {
   __call = function(_, ...) return System.new(...) end,
})
