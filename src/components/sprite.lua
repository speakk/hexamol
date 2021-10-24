local component = Concord.component("sprite", function(self, value, quad)
  self.value = value
  self.quad = quad
end)

return component

