return Concord.component("color", function(self, r, g, b, a)
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
