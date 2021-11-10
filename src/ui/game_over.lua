local helium = require 'libs.helium'

local menu_button = require 'ui.elements.menu_button'

local ui = {}

local function onClick()

end

local element = menu_button(
  {
    text = 'foo-bar',
    onClick = onClick,
    color = {1,0,1}
  }, 100, 50)

function ui:drawElements()
  element:draw(100, 100)
end

return ui
