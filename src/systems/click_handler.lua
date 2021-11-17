local ClickHandlerSystem = Concord.system({ selected = { "selected" }})
local push = require "libs.push.push"

function ClickHandlerSystem:handle_click(x, y, button)
  if button == 2 then
    for _, entity in ipairs(self.selected) do
      entity:remove("selected")
    end

    states.in_game.map:setLastFoundPath()
    return
  end

  local screenX, screenY = push:toGame(x, y)
  local hex = states.in_game.map:getHexFromPixelCoords(screenX, screenY)

  if hex then
    self:getWorld():emit("handle_map_click", hex, button)
  end
end

return ClickHandlerSystem

