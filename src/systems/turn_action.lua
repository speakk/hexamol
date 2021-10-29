local TurnActionSystem = Concord.system({ current_turn = { "current_turn", "team" }})

function TurnActionSystem:take_turn_action(team, action, options)
  assert(team.team, "No team provided for take_turn_action (or it didn't have the team component)")
  assert((#(self.current_turn) == 1), "Nobody has the current turn")

  local currentTeam = self.current_turn[1]
  if team ~= currentTeam then
    print("Team tried to perform an action outside of their turn")
    return
  end

  if currentTeam.action_points.value - (action.action_points or 0) < 0 then
    self:getWorld():emit("ran_out_of_action_points", { team = team })
    return
  end

  self:getWorld():emit(action.event_name, options, team)
  self:getWorld():emit("turn_action_taken", { team = team, action = action} )
end

return TurnActionSystem
