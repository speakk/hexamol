return Concord.component("helium", function(self, options)
  assert(options.ui_def, "Helium component must include ui_def")

  self.ui_def = options.ui_def
  self.active = options.active
end)
