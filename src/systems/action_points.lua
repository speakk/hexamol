local ActionPointsSystem = Concord.system({})

function ActionPointsSystem:turn_action_taken(options)
  local action_points = options.team.action_points
  action_points.value = action_points.value - (options.action.action_points or 0)
  print("action points now", action_points.value)

  if action_points.value <= 0 then
    self:getWorld():emit("ran_out_of_action_points", options.team)
    action_points.value = 0
  end
end

function ActionPointsSystem.end_turn(_, _, current_team)
  current_team.action_points.value = current_team.action_points.max
end

return ActionPointsSystem
