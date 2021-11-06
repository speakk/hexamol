local IsInHexSystem = Concord.system({ pool = { "is_in_hex" } })

function IsInHexSystem:update()
  for _, entity in ipairs(self.pool) do
    local x, y = states.in_game.map:getPixelCoordsFromHex(entity.is_in_hex.hex)
    entity.position.x = x
    entity.position.y = y
  end
end

function IsInHexSystem:place_entity_in_hex(entity, targetHex)
  if entity.is_in_hex then
    self:getWorld():emit("remove_entity_from_hex", entity, entity.is_in_hex.hex)
  end

  entity:give("is_in_hex", targetHex)
  --print("UM", inspect(targetHex))
  states.in_game.map:addEntityToHex(entity, targetHex)
end

function IsInHexSystem:kill_character(options)
  self:getWorld():emit("remove_entity_from_hex", options.character, options.character.is_in_hex.hex)
end

function IsInHexSystem.remove_entity_from_hex(_, entity, hex)
  entity:remove("is_in_hex")
  states.in_game.map:removeEntityFromHex(hex)
end

return IsInHexSystem

