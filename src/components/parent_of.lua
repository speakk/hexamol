return Concord.component("parent_of", function(self, children)
  self.children = children or error("parent_of needs children")
end)

