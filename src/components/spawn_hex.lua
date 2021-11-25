local component = Concord.component("spawn_hex", function(self, team)
  self.team_key = team.key.value
end)

function component:fetch(world)
  return world:getEntityByKey(self.team_key)
end

return component
