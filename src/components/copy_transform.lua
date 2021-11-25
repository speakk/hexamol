local component = Concord.component("copy_transform", function(self, target_entity, options)
  self.target_entity_key = target_entity.key.value or error("copy_transform needs target_entity")
  self.speed = options and options.speed
end)

function component:fetch(world)
  return world:getEntityByKey(self.target_entity_key)
end

return component

