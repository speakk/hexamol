local push = require 'libs.push.push'

local HoverHandlerSystem = Concord.system( {} )

function HoverHandlerSystem:update()
  local map = self:getWorld():getResource("map")
  map:update()
  local mouseX, mouseY = love.mouse.getPosition()
  -- TODO: Change when you implement a camera
  --local screenX, screenY = mouseX, mouseY
  local screenX, screenY = push:toGame(mouseX, mouseY)

  local hex = map:getHexFromPixelCoords(screenX, screenY)
  if hex then
    map.last_hovered_hex = hex
    --hex.selected = true
    self:getWorld():emit("hex_hovered", hex)
  end

end

return HoverHandlerSystem
