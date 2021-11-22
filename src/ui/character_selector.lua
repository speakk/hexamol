local font = love.graphics.newFont('media/fonts/m5x7.ttf', 16, "mono")

local function button_draw_func(self, x, y)
  love.graphics.setColor(self.currentColor)
  love.graphics.rectangle(
  'fill',
  self.x + (x or 0),
  self.y + (y or 0),
  self.w,
  self.h
  )

  if self.is_selected then
    love.graphics.setColor(1,1,1,1)
    love.graphics.rectangle(
    'line',
    self.x + (x or 0),
    self.y + (y or 0),
    self.w,
    self.h
    )
  end
end

local function createChild(character, select_character, is_selected)
  local button = require 'myui.elements.button'({
    layout = "horizontal",
    fillW = true,
    margin = 0,
    is_selected = is_selected,
    h = 50,
    draw_func = button_draw_func,
    onClick = function()
      select_character(character)
    end
  })

  button:addChild(require 'myui.elements.sprite'({
    sprite = character.entity.sprite.value,
    fillH = true,
  }))

  return button
end

return function(options)
  local container = require 'myui.elements.container'({
    layout = "vertical",
    fillW = true,
    growH = true,
    backgroundColor = {1.0, 0.7, 0.7, 0.9},
    id = options.id
  })

  container.setCharacters = function(self, characters, selected_character)
    self:emptyChildren()

    -- TODO: Make the selector itself a separate container so you don't have to recreate this text
    self:addChild(require 'myui.elements.text'({
      text = "Selected character",
      fillW = true,
      h = 30,
      margin = 0,
      align = "center",
      font = font,
      color = { 0, 0.4, 0.2 }
    }))

    for _, character in ipairs(characters) do
      self:addChild(createChild(character, options.select_character, selected_character == character))
    end
  end

  return container
end
