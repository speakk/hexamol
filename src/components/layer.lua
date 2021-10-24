local component = Concord.component("layer", function(self, name)
  self.name = name or error("No name provided for layer")
end)

return component


