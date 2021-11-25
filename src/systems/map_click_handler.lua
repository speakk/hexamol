local turn_actions = require 'models.turn_actions'

local MapClickHandlerSystem = Concord.system({
  playerTeams = { "player_controlled", "team", "current_turn" },
  isInMap = { "is_in_hex" },
  selected = { "selected" },
  ui_state = { "ui_state" }
})

function MapClickHandlerSystem:handle_map_click(hex)
  local team = self.playerTeams[1]

  local entity_exists_in_hex = states.in_game.map:getHexOccupants(hex)

  if entity_exists_in_hex then
    if entity_exists_in_hex.is_in_team:fetch(self:getWorld()) == team and entity_exists_in_hex.can_be_selected then
      self:getWorld():emit("select_entity", entity_exists_in_hex)
    elseif #(self.selected) > 0 and entity_exists_in_hex.is_in_team:fetch(self:getWorld()) ~= team then
      self:getWorld():emit("take_turn_action", team,
        turn_actions.move_and_attack,
        {
          unit = self.selected[1],
          against = entity_exists_in_hex,
        }
      )
    end
  elseif #(self.selected) > 0 then
    self:getWorld():emit("take_turn_action", team,
      turn_actions.move_entity,
      {
        target_hex = hex,
        unit = self.selected[1]
      }
    )
  elseif hex.spawn_hex and hex.spawn_hex:fetch(self:getWorld()) == team then
    print(self.ui_state[1])
    self:getWorld():emit("take_turn_action", team,
      turn_actions.place_character,
      {
        assemblage = self.ui_state[1].ui_state.selected_character.assemblage,
        target_hex = hex,
        team = team
      }
    )
  end
end

return MapClickHandlerSystem

