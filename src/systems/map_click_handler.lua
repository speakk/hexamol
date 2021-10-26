local MapClickHandlerSystem = Concord.system({ playerTeams = { "player_controlled", "team" }, isInMap = { "is_in_hex" }, selected = { "selected" } })

function MapClickHandlerSystem:handle_map_click(hex)
  local team = self.playerTeams[1]

  local entity_exists_in_hex = functional.find_match(self.isInMap, function(is_in_map_entity)
    return is_in_map_entity.is_in_hex.hex == hex
  end)

  if entity_exists_in_hex then
    self:getWorld():emit("select_entity", entity_exists_in_hex)
  elseif #(self.selected) > 0 then
    self:getWorld():emit("move_entities", self.selected, hex)
  else
    self:getWorld():emit("place_character", hex, team)
  end
end

return MapClickHandlerSystem
