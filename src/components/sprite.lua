local component = Concord.component("sprite", function(self, fileName, canvas)
  assert(fileName or canvas, "sprite needs fileName or canvas")
  self.fileName = fileName
  self.canvas = canvas
end)

function component:fetch()
  if self.fileName then
    return assets:get(self.fileName)
  else
    return self.canvas
  end
end

return component

