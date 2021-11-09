local BaseSystem = Concord.system({})

function BaseSystem:kill_character(options)
  local entity = options.character
  if not entity.base then return end

  self:getWorld():emit("base_destroyed", entity)
end

function BaseSystem:base_destroyed(entity)
  if entity.is_in_team.teamEntity.player_controlled then
    self:getWorld():emit("game_over", true)
  else
    self:getWorld():emit("game_over", false)
  end
end

return BaseSystem
