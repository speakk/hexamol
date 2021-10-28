local TurnActionSystem = Concord.system({ current_turn = { "current_turn", "team" }})

function TurnActionSystem:take_turn_action(team, action, options)
  assert(team.team, "No team provided for take_turn_action (or it didn't have the team component)")
  assert((#(self.current_turn) == 1), "Nobody has the current turn")

  local currentTeam = self.current_turn[1]
  if team ~= currentTeam then
    print("Team tried to perform an action outside of their turn")
    return
  end

  self:getWorld():emit(action.event_name, options)
end

return TurnActionSystem
