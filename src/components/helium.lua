return Concord.component("helium", function(self, options)
  assert(options.ui_element, "Helium component must include ui_element")

  self.ui_element = options.ui_element
  self.active = options.active
end)
