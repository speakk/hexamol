local UiSystem = Concord.system({})

function UiSystem:init(world)
  Concord.entity(world)
    :give("helium", {
      ui_def = require 'ui.main',
      active = true
    })
end

return UiSystem
