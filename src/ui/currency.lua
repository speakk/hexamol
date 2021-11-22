local font = love.graphics.newFont('media/fonts/ThaleahFat.ttf', 32, "mono")

return function()
  local _, screenH = push:getDimensions()

  local container = require 'myui.elements.container'({
    layout = "vertical",
    w = 80,
    h = screenH,
    backgroundColor = {0.2, 0.7, 0.5, 0.1},
    transform_func = function(x, y) return push:toGame(x, y) end
  })

  container:addChild(require 'myui.elements.text'({
    text = "Gold",
    font = font,
    color = { 1, 0.4, 0.2 }
  }))

  container:addChild(require 'myui.elements.text'({
    id = "gold_count",
    text = "0",
    font = font,
    color = { 1, 0.4, 0.2 }
  }))

  return container
end
