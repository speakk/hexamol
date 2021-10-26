local PlayerInputSystem = Concord.system({ pool = { "player_controlled", "current_turn" }})

function PlayerInputSystem:player_end_turn()
  for _, entity in ipairs(self.pool) do
    self:getWorld():emit("end_turn", entity)
  end
end

return PlayerInputSystem

