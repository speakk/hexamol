return Concord.component("child_of", function(self, parent)
  self.parent = parent or error("child_of needs parent")
end)

