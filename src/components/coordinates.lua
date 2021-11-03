return Concord.component("coordinates", function(self, q, r)
  self.q = q
  self.r = r
  self.s = -q-r
end)
