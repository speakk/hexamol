local component = Concord.component("is_in_team", function(self, team)
  self.team_key = team.key.value or error("is_in_team requires team")
end)

function component:fetch(world)
  return world:getEntityByKey(self.team_key)
end

return component

