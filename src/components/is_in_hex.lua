local component = Concord.component("is_in_hex", function(self, hex)
  self.hex_key = hex.key.value
end)

function component:fetch(world)
  return world:getEntityByKey(self.hex_key)
end

return component
