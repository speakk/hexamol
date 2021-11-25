local component = Concord.component("parent_of", function(self, children)
  assert(children, "parent_of needs children")
  self.children_keys = {}
  for _, child in ipairs(children) do
    table.insert(self.children_keys, child.key.value)
  end
end)

function component:fetch(world)
  return functional.map(self.children_keys, function(child_key)
    return world:getEntityByKey(child_key)
  end)
end

return component
