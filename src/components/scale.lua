local component = Concord.component("scale", function(self, value)
  self.value = value or 1
  self.original_scale = self.value
end)

return component


