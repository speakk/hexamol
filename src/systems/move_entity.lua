local MoveEntitySystem = Concord.system({})

function MoveEntitySystem.move_entities(_, entities, targetHex)
  for _, entity in ipairs(entities) do
    entity:remove("selected") -- TODO: Should unselecting be done elsewhere?
    local from = entity.is_in_hex.hex
    entity:give("wants_path", from, targetHex)
    entity:remove("has_path")
  end
end

return MoveEntitySystem
