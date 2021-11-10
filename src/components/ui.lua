return Concord.component("ui", function(self, options)
  assert(options.element, "UI component must include element")

  self.element = options.element
  self.active = options.active
end)
