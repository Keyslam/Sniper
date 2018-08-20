local Ffi = require("ffi")
local Lds = require("lds")

Ffi.cdef[[
   struct Position {
      float x, y;
   };
   struct Velocity {
      float x, y;
   };
   struct Circle {
      float r;
   };
   struct Rectangle {
      float w, h;
   };
]]

local EntityCount = 3000000

local Position_T = Ffi.typeof("struct Position")
local Position   = Lds.Array(Position_T, EntityCount)

local Velocity_T = Ffi.typeof("struct Velocity")
local Velocity   = Lds.Array(Velocity_T, EntityCount)

local Circle_T = Ffi.typeof("struct Circle")
local Circle   = Lds.Array(Circle_T, EntityCount)

local Rectangle_T = Ffi.typeof("struct Rectangle")
local Rectangle   = Lds.Array(Rectangle_T, EntityCount)

local lastID = -1
local function newEntity()
   lastID = lastID + 1
   return lastID
end

local Physics = {}
local CircleRenderer = {}
local RectangleRenderer = {}

for i = 0, EntityCount - 2 do
   local e = newEntity()

   Position:set_e(e, Position_T(love.math.random(0, 1160), love.math.random(0, 600)))
   Velocity:set_e(e, Velocity_T(love.math.random(10, 40), love.math.random(10, 40)))
   table.insert(Physics, e)

   if love.math.random() < 0.5 then
      Rectangle:set_e(e, Rectangle_T(love.math.random(20, 40), love.math.random(20, 40)))
      table.insert(RectangleRenderer, e)
   else
      Circle:set_e(e, Circle_T(love.math.random(10, 20)))
      table.insert(CircleRenderer, e)
   end
end

function love.update(dt)
   for i = 1, #Physics do
      local position = Position:get(i)
      local velocity = Velocity:get(i)

      position.x = position.x + velocity.x * dt
      position.y = position.y + velocity.y * dt
   end

   love.window.setTitle(love.timer.getFPS())
end

--[[
function love.draw()
   for i = 1, #RectangleRenderer do
      local position  = Position:get(i)
      local rectangle = Rectangle:get(i)

      --love.graphics.rectangle("fill", position.x, position.y, rectangle.w, rectangle.h)
   end

   for i = 1, #CircleRenderer do
      local position = Position:get(i)
      local circle   = Circle:get(i)

      --love.graphics.circle("fill", position.x, position.y, circle.r)
   end
end
]]
