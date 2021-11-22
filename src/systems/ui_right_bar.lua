local UIRightBarSystem = Concord.system({ teams = { "team" }, current_team = { "team", "current_turn" } })

local characterA = require 'assemblages.character_a'
local characterB = require 'assemblages.character_b'

local characters = { characterA, characterB }

function UIRightBarSystem:init(world)
  self.ui_entity = Concord.entity(world)
  :give("ui", {
    element = require 'ui.right_bar'({
      select_character = function(character)
        self.ui_state.ui_state.selected_character = character
        world:emit("spawn_character_selected", character)
      end
    }),
    active = true
  })

  -- TODO: Either make the ui_right_bar_state, or move ui_state out of this system
  self.ui_state = Concord.entity(world):give("ui_state")

  self.characters_by_team = {}
end

function UIRightBarSystem:initialize_map_entities()
  for teamIndex, _ in ipairs(self.teams) do
    self.characters_by_team[teamIndex] = {}
    for _, assemblage in ipairs(characters) do
      local entity = Concord.entity(self:getWorld()):assemble(assemblage, { teamIndex = teamIndex })
      table.insert(self.characters_by_team[teamIndex], {
        entity = entity,
        assemblage = assemblage
      })
    end
  end
end

function UIRightBarSystem:spawn_character_selected(character)
  local currentTeamIndex = table.index_of(self.teams, self.current_team[1])
  self.ui_state.ui_state.selected_character = character
  self.ui_entity.ui.element.children.characterSelector:
    setCharacters(
    self.characters_by_team[currentTeamIndex],
    self.ui_state.ui_state.selected_character
    )
end

function UIRightBarSystem:turn_starts(team)
  local teamIndex = table.index_of(self.teams, team)
  local teamCharacters = self.characters_by_team[teamIndex]

  self.ui_state.ui_state.selected_character = teamCharacters[1]

  self.ui_entity.ui.element.children.characterSelector:
    setCharacters(
      teamCharacters,
      self.ui_state.ui_state.selected_character
      )
end

return UIRightBarSystem

