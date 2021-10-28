local MoveEntitySystem = Concord.system({})

function MoveEntitySystem.move_entities(_, options)
  for _, entity in ipairs(options.entities) do
    entity:remove("selected") -- TODO: Should unselecting be done elsewhere?
    local from = entity.is_in_hex.hex
    entity:give("wants_path", from, options.target_hex)
    entity:remove("has_path")
  end
end

return MoveEntitySystem
