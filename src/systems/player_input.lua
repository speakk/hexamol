local turn_actions = require 'models.turn_actions'

local PlayerInputSystem = Concord.system({ pool = { "player_controlled", "current_turn" }})

function PlayerInputSystem:player_end_turn()
  for _, entity in ipairs(self.pool) do
    self:getWorld():emit("take_turn_action", entity, turn_actions.end_turn)
  end
end

return PlayerInputSystem

