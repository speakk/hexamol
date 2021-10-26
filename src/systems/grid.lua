local push = require 'libs.push.push'
local GridSystem = Concord.system({ in_map = { "is_in_hex" } })

function GridSystem:init(world)
  --self.canvas = love.graphics.newCanvas(push:getDimensions())
  self.canvas = love.graphics.newCanvas(love.graphics:getDimensions())
  print(self.canvas:getDimensions())
  self.mapDrawEntity = Concord.entity(world)
    :give("sprite", self.canvas)
    :give("position")
    :give("origin", 0, 0)
    :give("layer", "world")

  self.in_map.entityAdded = function(_, entity)
    local hex = entity.is_in_hex.hex
    states.in_game.map:addEntityToHex(entity, hex)
  end

  self.in_map.entityRemoved = function(_, entity)
    states.in_game.map:removeEntity(entity)
  end
end

function GridSystem:update()
  states.in_game.map:update()
  local mouseX, mouseY = love.mouse.getPosition()
  -- TODO: Change when you implement a camera
  --local screenX, screenY = mouseX, mouseY
  local screenX, screenY = push:toGame(mouseX, mouseY)

  local hex = states.in_game.map:getHexFromPixelCoords(screenX, screenY)
  if hex then
    hex.selected = true
  end
end

function GridSystem:draw()
  -- love.graphics.setCanvas(self.canvas)
  -- love.graphics.clear(0,0,0,0)
  love.graphics.setColor(1,1,1,1)
  states.in_game.map:draw()
  --love.graphics.setCanvas()
end

return GridSystem
