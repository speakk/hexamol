local push = require 'libs.push.push'
local GridSystem = Concord.system({})

function GridSystem:init(world)
  self.canvas = love.graphics.newCanvas(push:getDimensions())
  print(self.canvas:getDimensions())
  self.mapDrawEntity = Concord.entity(world)
    :give("sprite", self.canvas)
    :give("position")
    :give("origin", 0, 0)
    :give("layer", "world")
end

function GridSystem:update()
  states.in_game.map:update()
  local mouseX, mouseY = love.mouse.getPosition()
  local screenX, screenY = push:toGame(mouseX, mouseY)

  local hex = states.in_game.map:getHexFromPixelCoords(screenX, screenY)
  if hex then
    hex.selected = true
  end
end

function GridSystem:draw()
  love.graphics.setCanvas(self.canvas)
  love.graphics.setColor(1,1,1,1)
  states.in_game.map:draw()
  love.graphics.setCanvas()
end

return GridSystem
