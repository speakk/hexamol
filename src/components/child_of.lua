local component = Concord.component("child_of", function(self, parent)
  self.parent_key = parent.key.value or error("child_of needs parent")
end)

function component:fetch(world)
  return world:getEntityByKey(self.parent_key)
end

return component
