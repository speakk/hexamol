local TurnSystem = Concord.system({ pool = { "team" }, current_turn = { "team", "current_turn" }, selected = { "selected" } })

function TurnSystem:end_turn(_, current_team)
  current_team:remove("current_turn")

  local current_index = table.index_of(self.pool, current_team)
  local next_turn_index = math.wrap(current_index + 1, 1, #(self.pool)+1)

  local next_turn = self.pool[next_turn_index]

  -- TODO: Currently flush is needed to make sure "current turn" is
  -- on the correct entity. Figure out a way out of this.
  self:getWorld():__flush()
  self:getWorld():emit("start_turn", next_turn)
end

function TurnSystem:start_turn(team)
  if not team then
    team = self.pool[1]
  end

  team:give("current_turn")

  self:getWorld():emit("turn_starts", team)
end

function TurnSystem:turn_starts(team)
  -- TODO: Move this unselection out from here
  for _, entity in ipairs(self.selected) do
    entity:remove("selected")
  end
  print("Turn started:", team, team.ai_controlled)

  if team.ai_controlled then
    self:getWorld():emit("run_ai_turn", team)
  end

  self:getWorld():emit("change_currency", {
    team = team,
    amount = 1
  })
end

return TurnSystem
