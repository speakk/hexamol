local MoveEntitySystem = Concord.system({})

function MoveEntitySystem.move_entities(_, entities, targetHex)
  for _, entity in ipairs(entities) do
    entity:give("is_in_hex", targetHex)
    entity:remove("selected") -- TODO: Should unselecting be done elsewhere?
  end
end

return MoveEntitySystem
