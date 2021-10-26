local SelectEntity = Concord.system({})

function SelectEntity.select_entity(_, entity)
  entity:give("selected")
end

return SelectEntity
