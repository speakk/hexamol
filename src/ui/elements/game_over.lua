local helium = require 'libs.helium'
local containerScheme = require 'libs.helium.layout.container'

local game_over_menu_factory = require 'ui.elements.game_over_menu'

return helium(function(param, view)
  print("Game over init", view.x, view.y, view.w, view.h)
  local game_over_menu = game_over_menu_factory({}, 400, 400)

  return function()
    local container = containerScheme.new("center", "center")
    game_over_menu:draw()
    container:draw()
  end
end)


