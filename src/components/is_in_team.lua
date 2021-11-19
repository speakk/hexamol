local component = Concord.component("is_in_team", function(self, team)
  self.team = team or error("is_in_team requires team")
end)

return component


