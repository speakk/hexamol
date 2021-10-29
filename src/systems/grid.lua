--local push = require 'libs.push.push'
local GridSystem = Concord.system({ })

-- function GridSystem:init(world)
--   --self.canvas = love.graphics.newCanvas(push:getDimensions())
--   -- self.canvas = love.graphics.newCanvas(love.graphics:getDimensions())
--   -- self.mapDrawEntity = Concord.entity(world)
--   --   :give("sprite", self.canvas)
--   --   :give("position")
--   --   :give("origin", 0, 0)
--   --   :give("layer", "world")
-- end

function GridSystem.draw()
  -- love.graphics.setCanvas(self.canvas)
  -- love.graphics.clear(0,0,0,0)
  love.graphics.setColor(1,1,1,1)
  states.in_game.map:draw()
  --love.graphics.setCanvas()
end

function GridSystem.frame_start()
  states.in_game.map:frameStart()
end

return GridSystem
