local PlaceCharacterSystem = Concord.system({ teams = { "team" }})

function PlaceCharacterSystem:place_character(options)
  assert(options.target_hex, "Hex not provided to place_character")

  print("Placing?", options.target_hex)

  local teamIndex = table.index_of(self.teams, options.team)

  local entity = Concord.entity(self:getWorld())
    :assemble(options.assemblage, { teamIndex = teamIndex })
    :give("is_in_team", options.team)

  self:getWorld():emit("place_entity_in_hex", entity, options.target_hex)
  print("placed in...", options.target_hex.coordinates.q, options.target_hex.coordinates.r)
end

return PlaceCharacterSystem
