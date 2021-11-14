return Concord.component("health_bar", function(self, target_entity)
  self.target_entity = target_entity or error("health_bar needs target_entity")
end)
