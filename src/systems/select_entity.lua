local SelectEntity = Concord.system({ selected = { "selected" }})

function SelectEntity:select_entity(entity)
  for _, selected in ipairs(self.selected) do
    selected:remove("selected")
  end
  entity:give("selected")
end

return SelectEntity
