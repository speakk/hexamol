local InputSystem = Concord.system({})

local keyMap = {
  {
    key = "space",
    event = "player_end_turn",
    singlePress = true
  }
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
  -- button HAPPENS to correspond to team number (1 or 2) so we use it directly here
  self:getWorld():emit("handle_click", x, y, button)
end

return InputSystem
