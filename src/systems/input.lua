local InputSystem = Concord.system({})

local keyMap = {
}

local repeatKeys = {}
local singlePressKeys = {}
for _, keyDefinition in ipairs(keyMap) do
  if keyDefinition.singlePress then
    table.push(singlePressKeys, keyDefinition)
  else
    table.push(repeatKeys, keyDefinition)
  end
end

function InputSystem:update()
  for _, keyDefinition in ipairs(repeatKeys) do
    if love.keyboard.isDown(keyDefinition.key) then
      self:getWorld():emit(keyDefinition.event)
    end
  end
end

function InputSystem:key_pressed(key)
  for _, keyDefinition in ipairs(singlePressKeys) do
    if key == keyDefinition.key then
      self:getWorld():emit(keyDefinition.event)
    end
  end
end

function InputSystem:mouse_pressed(x, y, button)
  print("button", button)
  if (button == 1) then
    self:getWorld():emit("place_character", x, y)
  end
end

return InputSystem
