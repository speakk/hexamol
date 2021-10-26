local ClickHandlerSystem = Concord.system({})
local push = require "libs.push.push"

function ClickHandlerSystem:handle_click(x, y, button)
  local screenX, screenY = push:toGame(x, y)
  local hex = states.in_game.map:getHexFromPixelCoords(screenX, screenY)

  if hex then
    self:getWorld():emit("handle_map_click", hex, button)
  end
end

return ClickHandlerSystem

