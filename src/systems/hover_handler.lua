local push = require 'libs.push.push'

local HoverHandlerSystem = Concord.system( {} )

function HoverHandlerSystem:update()
  states.in_game.map:update()
  local mouseX, mouseY = love.mouse.getPosition()
  -- TODO: Change when you implement a camera
  --local screenX, screenY = mouseX, mouseY
  local screenX, screenY = push:toGame(mouseX, mouseY)

  local hex = states.in_game.map:getHexFromPixelCoords(screenX, screenY)
  if hex then
    states.in_game.map.last_hovered_hex = hex
    hex.selected = true
    self:getWorld():emit("hex_hovered", hex)
  end
end

return HoverHandlerSystem
