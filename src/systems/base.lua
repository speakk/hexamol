local BaseSystem = Concord.system({})

function BaseSystem:kill_character(options)
  local entity = options.character
  if not entity.base then return end

  self:getWorld():emit("base_destroyed", {
    by = options.by,
    base = entity
  })
end

function BaseSystem:base_destroyed(options)
  self:getWorld():emit("game_over", options.by.is_in_team.team)
end

return BaseSystem
