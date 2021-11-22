return Concord.component("action_points", function(self, value, max)
  self.value = value
  self.max = max or value
end)
