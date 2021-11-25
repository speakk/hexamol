local ActionPointsSystem = Concord.system({ pool = { "action_points", "is_in_hex" }, bars = { "action_point_bar" } })

function ActionPointsSystem:use_action_points(options)
  local action_points = options.unit.action_points
  action_points.value = action_points.value - options.amount
  print("action points now", action_points.value)

  if action_points.value <= 0 then
    self:getWorld():emit("ran_out_of_action_points", options.unit)
    action_points.value = 0
  end

  self:getWorld():emit("action_points_changed", options.unit)
end

function ActionPointsSystem:turn_starts(team)
  for _, unit in ipairs(self.pool) do
    if unit.is_in_team:fetch(self:getWorld()) == team then
      unit.action_points.value = unit.action_points.max
      self:getWorld():emit("action_points_changed", unit)
    end
  end
end

return ActionPointsSystem
