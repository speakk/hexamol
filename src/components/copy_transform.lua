return Concord.component("copy_transform", function(self, target_entity, options)
  self.target_entity = target_entity or error("copy_transform needs target_entity")
  self.speed = options and options.speed
end)
