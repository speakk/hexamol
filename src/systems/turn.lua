local TurnSystem = Concord.system({ pool = { "team" }, current_turn = { "team", "current_turn" } })

function TurnSystem.init(_, world)
  -- TODO: Team initialization away from turn system init
  Concord.entity(world):give("team", "player"):give("current_turn"):give("player_controlled")
  Concord.entity(world):give("team", "ai"):give("ai_controlled")
end

function TurnSystem:end_turn(teamEntity)
  teamEntity:remove("current_turn")

  local current_index = table.index_of(self.pool, teamEntity)
  local next_turn_index = math.wrap(current_index + 1, 1, #(self.pool)+1)

  local next_turn = self.pool[next_turn_index]
  next_turn:give("current_turn")

  -- TODO: Currently flush is needed to make sure "current turn" is
  -- on the correct entity. Figure out a way out of this.
  self:getWorld():__flush()
  self:getWorld():emit("turn_starts", next_turn)
end

function TurnSystem:turn_starts(teamEntity)
  print("Turn started:", teamEntity, teamEntity.ai_controlled)

  if teamEntity.ai_controlled then
    self:getWorld():emit("run_ai_turn", teamEntity)
  end
end

return TurnSystem
