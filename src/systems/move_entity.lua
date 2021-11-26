local MoveEntitySystem = Concord.system({})

function MoveEntitySystem:move_entity(options)
  local entity = options.unit
  entity:remove("selected") -- TODO: Should unselecting be done elsewhere?

  if options.path then
    entity:give("has_path", options.path, options.finish_path_action)
  else
    local from = entity.is_in_hex:fetch(self:getWorld())
    entity:give("wants_path", from, options.target_hex, options.finish_path_action)
    entity:remove("has_path")
  end
  self:getWorld():getResource("map"):setLastFoundPath(nil)
end

return MoveEntitySystem
