local AiSystem = Concord.system({})

function AiSystem:run_ai_turn(teamEntity)
  -- TODO: Make it do stuff!

  local randomHex = states.in_game.map:getRandomFreeHex()
  self:getWorld():emit("place_character", randomHex, teamEntity)

  tick.delay(function()
    self:getWorld():emit("end_turn", teamEntity)
  end, 2)
end

return AiSystem
