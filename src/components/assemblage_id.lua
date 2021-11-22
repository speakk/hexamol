return Concord.component("assemblage_id", function(self, id)
  self.value = id or error("assemblage_id needs value")
end)
