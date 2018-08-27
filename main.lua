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
   int x, y;
]], "Position")

local Velocity = Component([[
   float x, y;
]], "Velocity")

local Sprite = Component([[
   int texture;
]], "Sprite")

-- Setting up systems

local Physics = System({Position, Velocity})


local SpriteRenderer = System({Position, Sprite})
function SpriteRenderer:draw()
   for i = 1, SpriteRenderer.count do
      local id = Physics:get(i)

      local position = Position:get(id)
      local sprite   = Sprite:get(id)

      local texture = Textures[sprite.texture]
      --love.graphics.draw(texture, position.x, position.y, nil, 0.1, 0.1)
   end
end

local ents = {}

local s1 = love.timer.getTime()
for i = 1, 1000000 do
   ents[i] = Entity()
   :give(Position, 0, 0)
   :give(Velocity, 10, 10)
   :give(Sprite, 1)
   :filter()
end
local e1 = love.timer.getTime()
print(e1-s1)
