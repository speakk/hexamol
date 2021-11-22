local w = 80

return function(options)
  local screenW, screenH = push:getDimensions()

  local container = require 'myui.elements.container'({
    layout = "vertical",
    w = w,
    h = screenH,
    x = screenW - w,
    backgroundColor = {0.2, 0.7, 0.5, 0.1},
    transform_func = function(x, y) return push:toGame(x, y) end
  })

  container:addChild(require 'ui.character_selector'({
    id = "characterSelector",
    select_character = options.select_character
  }))

  return container
end

