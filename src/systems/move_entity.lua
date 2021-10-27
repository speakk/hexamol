local MoveEntitySystem = Concord.system({})

function MoveEntitySystem.move_entities(self, entities, targetHex)
  for _, entity in ipairs(entities) do
    entity:remove("is_in_hex")
    self:getWorld():__flush()
    entity:give("is_in_hex", targetHex)
    entity:remove("selected") -- TODO: Should unselecting be done elsewhere?
    entity:remove("wants_path")
    entity:remove("has_path")
  end
end

return MoveEntitySystem
