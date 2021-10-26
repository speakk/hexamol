return Concord.component("team", function(self, name)
  self.name = name or error "Team needs name"
end)
