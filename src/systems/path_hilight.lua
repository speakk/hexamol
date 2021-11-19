local PathHilightSystem = Concord.system( { selected = { "selected", "is_in_hex" }, player_controlled = { "player_controlled", "team" } } )

function PathHilightSystem:hex_hovered(hex)
  self.last_hovered_hex = hex
end

function PathHilightSystem:isEntityEnemy(entity)
  if not entity then return end
  local playerTeam = self.player_controlled[1]
  if not playerTeam then return end

  if entity.is_in_team.team ~= playerTeam then
    return true
  end
end

function PathHilightSystem:update(dt)
  if states.in_game.map.last_hovered_hex then
    local hexEntity = states.in_game.map:getHexOccupants(states.in_game.map.last_hovered_hex)
    local containsEnemies = self:isEntityEnemy(hexEntity)

    for _, entity in ipairs(self.selected) do
      local from = entity.is_in_hex.hex
      local path
      local range = entity.movement_range and entity.movement_range.value or nil
      if containsEnemies then
        path = states.in_game.path_finder:find_path(from, states.in_game.map.last_hovered_hex, range, { states.in_game.map.last_hovered_hex }, true)
      else
        path = states.in_game.path_finder:find_path(from, states.in_game.map.last_hovered_hex, range)
      end

      if path then
        states.in_game.map:setLastFoundPath(path)
      end
    end
  end
end

return PathHilightSystem
