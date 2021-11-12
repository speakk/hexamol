local helium = require 'libs.helium'
local layoutScheme = require 'libs.helium.layout.column'

local menu_button = require 'ui.elements.menu_button'

local function new_game_click()
  print("Clicking")
end

return helium(function(param, view)
  print("Game over menu init")
  local new_game_button = menu_button({
    text = 'New game',
    onClick = new_game_click,
    color = {1,0,1}
  }, 100, 50)

  return function()
    --local x,y = 100, 100
    print("Game over menu draw")
    local layout = layoutScheme.new()
    --local container = containerScheme.new("center", "center")
    new_game_button:draw()
    layout:draw()
    --container:draw()
  end
end)

