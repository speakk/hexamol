local component = Concord.component("health_bar", function(self, target_entity)
  self.target_entity_key = target_entity.key.value or error("health_bar needs target_entity")
end)

function component:fetch(world)
  return world:getEntityByKey(self.target_entity_key)
end

return component
