return Concord.component("action_point_bar", function(self, target_entity)
  self.target_entity = target_entity or error("action_point_bar needs target_entity")
end)

