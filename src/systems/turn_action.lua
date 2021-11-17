local turn_actions = require 'models.turn_actions'

local TurnActionSystem = Concord.system({ current_turn = { "current_turn", "team" }})

function TurnActionSystem:take_turn_action(team, action, options)
  assert(team.team, "No team provided for take_turn_action (or it didn't have the team component)")
  assert((#(self.current_turn) == 1), "Nobody has the current turn")

  local currentTeam = self.current_turn[1]
  if team ~= currentTeam then
    print("Team tried to perform an action outside of their turn")
    return
  end

  local can_perform_action = turn_actions.can_perform_action(action, {
    team = team,
    unit = options and options.unit
  }, self:getWorld())

  print("Can perform?", can_perform_action)
  if not can_perform_action then return end

  if action.currency_cost then
    self:getWorld():emit("use_currency", { team = team, amount = action.currency_cost })
  end

  if action.action_point_cost then
    self:getWorld():emit("use_action_points", { unit = options.unit, amount = action.action_point_cost })
  end

  self:getWorld():emit(action.event_name, options, team)
  self:getWorld():emit("turn_action_taken", { team = team, action = action} )
end

return TurnActionSystem
