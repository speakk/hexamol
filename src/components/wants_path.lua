local component = Concord.component("wants_path", function(self, from, to, finish_path_action)
  self.from_key = from.key.value
  self.to_key = to.key.value
  self.finish_path_action = finish_path_action
end)

function component:fetchFrom(world)
  return world:getEntityByKey(self.from_key)
end

function component:fetchTo(world)
  return world:getEntityByKey(self.to_key)
end

return component
