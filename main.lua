-- Loading the ECS
local Sniper = require("sniper")

local Entity    = Sniper.entity
local Component = Sniper.component
local System    = Sniper.system

-- Setting up textures
local Textures = {
   love.graphics.newImage("stone.png"),
}

-- Setting up components
local Position = Component([[
   float x, y;
]], "Position")

local Velocity = Component([[
   float x, y;
]], "Velocity")

local Sprite = Component([[
   int texture;
]], "Sprite")

-- Setting up systems

local Physics = System({Position, Velocity})
local maxX, maxY = love.graphics.getDimensions()

function Physics:update(dt)
   for i = 0, Physics.count - 1 do
      local id = Physics:get(i)

      local maxX, maxY = maxX, maxY

      local position = Position:get(id)
      local velocity = Velocity:get(id)

      position.x = position.x + velocity.x * dt
      position.y = position.y + velocity.y * dt

      if position.x > maxX or
         position.y > maxY then

         position.x = 0
         position.y = 0
      end
   end
end

local SpriteRenderer = System({Position, Sprite})
function SpriteRenderer:draw()
   for i = 0, SpriteRenderer.count - 1 do
      local id = SpriteRenderer:get(i)

      local position = Position:get(id)
      local sprite   = Sprite:get(id)

      local texture = Textures[sprite.texture]
      --love.graphics.draw(texture, position.x, position.y, nil, 0.05, 0.05)
   end
end


local ents = {}

for i = 1, 1000000 do
   ents[i] = Entity()
   :give(Position, 0, 0)
   :give(Velocity, love.math.random(20, 30), love.math.random(20, 30))
   :give(Sprite, 1)
   :filter()
end

Physics:flush()
SpriteRenderer:flush()


function love.update(dt)
   Physics:update(dt)

   love.window.setTitle(love.timer.getFPS())
end

function love.draw()
   SpriteRenderer:draw()
end

function love.keypressed(key)

   if key == "a" then
      local s = love.timer.getTime()
      for id = 1, #ents do
         ents[id]:destroy()
      end
      local e = love.timer.getTime()
      print(e - s)
   else
      local s = love.timer.getTime()
      Physics:flush()
      SpriteRenderer:flush()
      local e = love.timer.getTime()
      print(e - s)
   end
end
