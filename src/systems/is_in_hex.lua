local IsInHexSystem = Concord.system({ pool = { "is_in_hex" } })

function IsInHexSystem:init()
  self.pool.onAdded = function(_, entity)
    self:getWorld():getResource("map"):addEntityToHex(entity, entity.is_in_hex:fetch(self:getWorld()))
  end
end

function IsInHexSystem:update()
  for _, entity in ipairs(self.pool) do
    local x, y = self:getWorld():getResource("map"):getPixelCoordsFromHex(entity.is_in_hex:fetch(self:getWorld()))
    entity.position.x = x
    entity.position.y = y
  end
end

function IsInHexSystem:place_entity_in_hex(entity, targetHex)
  if entity.is_in_hex then
    self:getWorld():emit("remove_entity_from_hex", entity, entity.is_in_hex:fetch(self:getWorld()))
  end

  entity:give("is_in_hex", targetHex)
  --print("UM", inspect(targetHex))
end

function IsInHexSystem:kill_character(options)
  self:getWorld():emit("remove_entity_from_hex", options.character, options.character.is_in_hex:fetch(self:getWorld()))
end

function IsInHexSystem:remove_entity_from_hex(entity, hex)
  entity:remove("is_in_hex")
  self:getWorld():getResource("map"):removeEntityFromHex(hex)
end

return IsInHexSystem

