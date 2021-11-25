local component = Concord.component("color", function(self, r, g, b, a)
  self.r = r or 1
  self.g = g or 1
  self.b = b or 1
  self.a = a or 1

  self.original = {
    r = self.r,
    g = self.g,
    b = self.b,
    a = self.a,
  }
end)

function component:serialize()
  return {
    r = self.r,
    g = self.g,
    b = self.b,
    a = self.a,
    originalR = self.originalR,
    originalG = self.originalG,
    originalB = self.originalB,
    originalA = self.originalA,
  }
end

function component:deserialize(data)
  self.r = data.r
  self.g = data.g
  self.b = data.b
  self.a = data.a
  self.original = {
    r = data.originalR,
    g = data.originalG,
    b = data.originalB,
    a = data.originalA
  }
end

return component

