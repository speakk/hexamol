local IsInHexSystem = Concord.system({ pool = { "is_in_hex" } })

function IsInHexSystem:update()
  for _, entity in ipairs(self.pool) do
    local x, y = states.in_game.map:getPixelCoordsFromHex(entity.is_in_hex.hex)
    entity.position.x = x
    entity.position.y = y
  end
end

return IsInHexSystem

