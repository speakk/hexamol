local push = require 'libs.push.push'
local GridSystem = Concord.system({})

local Map = require 'models.map'

function GridSystem:init()
  self.map = Map(300, 250, 6)
end

function GridSystem:update()
  self.map:update()
  local mouseX, mouseY = love.mouse.getPosition()
  local screenX, screenY = push:toGame(mouseX, mouseY)

  local hex = self.map:getHexFromPixelCoords(screenX, screenY)
  print(mouseX, mouseY, hex)
  if hex then
    hex.selected = true
  end
end

function GridSystem:draw()
  self.map:draw()
end

return GridSystem
