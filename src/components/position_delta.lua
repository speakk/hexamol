local component = Concord.component("position_delta", function(self, x, y)
  self.x = x or 0
  self.y = y or 0
end)

return component

