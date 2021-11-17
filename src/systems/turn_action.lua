local TurnActionSystem = Concord.system({ current_turn = { "current_turn", "team" }})

function TurnActionSystem:take_turn_action(team, action, options)
  assert(team.team, "No team provided for take_turn_action (or it didn't have the team component)")
  assert((#(self.current_turn) == 1), "Nobody has the current turn")

  local currentTeam = self.current_turn[1]
  if team ~= currentTeam then
    print("Team tried to perform an action outside of their turn")
    return
  end

  if action.currency_cost then
    local holds_currency = currentTeam.holds_currency
    print("holds_currency", holds_currency.value, action.currency_cost)
    if holds_currency.value < action.currency_cost then
      self:getWorld():emit("ran_out_of_currency", { team = team })
      return
    else
      self:getWorld():emit("use_currency", { team = team, amount = action.currency_cost })
    end
  end

  if action.action_point_cost then
    if options.unit.action_points.value < action.action_point_cost then
      self:getWorld():emit("no_action_points_left_for_unit", { unit = options.unit })
      return
    else
      self:getWorld():emit("use_action_points", { unit = options.unit, amount = action.action_point_cost })
    end
  end

  self:getWorld():emit(action.event_name, options, team)
  self:getWorld():emit("turn_action_taken", { team = team, action = action} )
end

return TurnActionSystem
