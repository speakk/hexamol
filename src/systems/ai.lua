local AiSystem = Concord.system({})

function AiSystem:run_ai_turn(teamEntity)
  -- TODO: Make it do stuff!

  self:getWorld():emit("end_turn", teamEntity)
end

return AiSystem
