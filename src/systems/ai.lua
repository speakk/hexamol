local turn_actions = require 'models.turn_actions'
local AiSystem = Concord.system({
  ai_teams = { "team", "ai_controlled" },
  in_team = { "is_in_team", "is_in_hex" },
  bases = { "base" },
  current = { "current_turn", "team", "ai_controlled" },
  spawn_hexes = { "spawn_hex" },
  all_in_map = { "is_in_hex" }
})

function AiSystem:evaluate_game_state(team)
  local ownPoints = 0
  local othersPoints = 0

  for _, entity in ipairs(self.in_team) do
    local entityPoints = entity.health.value + entity.movement_range.value
    if entity.base then
      entityPoints = entityPoints + 10
    end
    if entity.is_in_team:fetch(self:getWorld()) == team then
      ownPoints = ownPoints + entityPoints
    else
      othersPoints = othersPoints + entityPoints
    end
  end

  return ownPoints - othersPoints
end

function AiSystem:copy_world()
  local current_world_data = self:getWorld():serialize()
  local new_world = Concord.world()

  new_world:addSystems(
    ECS.s.turn, ECS.s.attack, ECS.s.turn_action,
    ECS.s.ai, ECS.s.health, ECS.s.kill, ECS.s.action_points,
    ECS.s.select_entity, ECS.s.move_entity, ECS.s.place_character, ECS.s.is_in_hex,
    ECS.s.path_finding, ECS.s.grid,
    ECS.s.spawn_teams,
    ECS.s.base, ECS.s.parent_of,
    ECS.s.currency
  )

  new_world:deserialize(current_world_data)
  return new_world
end

function AiSystem:getViableMovesForCharacter(character)
  --local hexesWithinRadius = Gamestate.h
end

function AiSystem:getFreeSpawnHex(team)
  local teamHexes = functional.filter(self.spawn_hexes, function(hex)
    return hex.spawn_hex:fetch(self:getWorld()) == team
  end)

  return table.pick_random(teamHexes)
end

function AiSystem:getTeamEntities(team)
  return functional.filter(self.in_team, function(entity)
    if entity.is_in_team:fetch(self:getWorld()) == team and not entity.base then
      return true
    end
  end)
end

local action_delay = 1

function AiSystem:run_ai_turn(_team)
  self.action_delay_timer = action_delay
  print("run_ai_turn", action_delay)
end

local actions = {
  {
    -- Random move
    isViable = function(self, team)
      local aiEntities = self:getTeamEntities(team)
      local viable_entities = functional.filter(aiEntities, function(entity)
        return turn_actions.can_perform_action(turn_actions.move_entity, {
          team = team, unit = entity
        }, self:getWorld())
      end)
      if not viable_entities or #viable_entities == 0 then
        return false
      end

      return viable_entities
    end,
    run = function(self, team, aiEntities)
      assert(aiEntities)
      local randomEntity = table.pick_random(aiEntities)
      local newRandomHex = self:getWorld():getResource("map"):getRandomFreeHex()
      if (newRandomHex) then
        self:getWorld():emit("take_turn_action", team,
        turn_actions.move_entity,
        {
          target_hex = newRandomHex,
          unit = randomEntity
        }
        )
      end
    end,
    weight = 0.1
  },
  {
    -- Random place
    isViable = function(self, team)
      local can_perform_action = turn_actions.can_perform_action(turn_actions.place_character, { team = team }, self:getWorld())
      if can_perform_action then
        return self:getFreeSpawnHex(team)
      else
        return false
      end
    end,
    run = function(self, team, randomHex)
      assert(randomHex)
      local characters = { require 'assemblages.character_a', require 'assemblages.character_b' }
      self:getWorld():emit("take_turn_action", team,
        turn_actions.place_character,
        {
          target_hex = randomHex,
          team = team,
          assemblage = table.pick_random(characters)
        }
      )
    end,
    weight = 0.2
  },
  {
    -- Random attack
    isViable = function(self, team)
      local aiEntities = self:getTeamEntities(team)
      if not aiEntities or #aiEntities == 0 then return false end

      local enemies = functional.filter(self.all_in_map, function(entity)
        return entity.is_in_team:fetch(self:getWorld()) ~= team
      end)

      local can_perform_action = functional.filter(aiEntities, function(entity)
        return turn_actions.can_perform_action(turn_actions.move_and_attack, {
          team = team, unit = entity
        }, self:getWorld())
      end)

      local enemiesInRangeMap = {}
      local world = self:getWorld()

      local has_enemy_in_range = functional.filter(can_perform_action, function(entity)
        local enemies_in_range = functional.filter(enemies, function(enemy)
          local is_in_range = world:getResource("map"):getDistance(entity.is_in_hex:fetch(world), enemy.is_in_hex:fetch(world))
          return is_in_range
        end)

        -- Just a small optimization, stores enemies in range for later
        -- so we don't have to fetch them again
        enemiesInRangeMap[entity] = enemies_in_range

        return enemies_in_range and #enemies_in_range > 0
      end)


      if not enemies or #enemies == 0 then return false end
      if not has_enemy_in_range or #has_enemy_in_range == 0 then return false end

      local random_entity = table.pick_random(has_enemy_in_range)
      local random_enemy = table.pick_random(enemiesInRangeMap[random_entity])

      return {
        random_entity = random_entity,
        random_enemy = random_enemy
      }
    end,
    run = function(self, team, data)
      assert(data.random_enemy)
      assert(data.random_entity)
      local random_enemy = data.random_enemy
      local random_entity = data.random_entity

      self:getWorld():emit("take_turn_action", team,
        turn_actions.move_and_attack,
        {
          unit = random_entity,
          against = random_enemy
        }
      )
    end,
    weight = 0.5
  },
  {
    -- Attack base
    isViable = function(self, team)
      local enemy_base = functional.find_match(self.bases, function(base)
        return base.is_in_team:fetch(self:getWorld()) ~= team
      end)

      local aiEntities = self:getTeamEntities(team)
      if not aiEntities or #aiEntities == 0 then return false end

      local can_perform_action = functional.filter(aiEntities, function(entity)
        return turn_actions.can_perform_action(turn_actions.move_and_attack, {
          team = team, unit = entity
        }, self:getWorld())
      end)

      local random_entity = table.pick_random(can_perform_action)

      if not enemy_base then return false end
      if not random_entity then return false end

      return {
        enemy_base = enemy_base,
        random_entity = random_entity
      }
    end,
    run = function(self, team, data)
      assert(data.enemy_base)
      assert(data.random_entity)

      self:getWorld():emit("take_turn_action", team,
        turn_actions.move_and_attack,
        {
          unit = data.random_entity,
          against = data.enemy_base
        }
      )
    end,
    total_action_points = turn_actions.move_and_attack.action_points,
    weight = 4
  }
}

function AiSystem:do_random_action(team)
  local action_datas = {}
  local viable_actions = functional.filter(actions, function(action)
    local action_data = action.isViable(self, team)
    if action_data then
      action_datas[action] = action_data
      return true
    end
  end)

  if #viable_actions == 0 then return false end

  local weights = functional.map(viable_actions, function(action) return action.weight end)
  local action = table.pick_weighted_random(viable_actions, weights)

  local _ = action.run(self, team, action_datas[action])
  return true
end

function AiSystem:update(dt)
  local current = self.current[1]
  if not current then return end

  self.action_delay_timer = self.action_delay_timer - dt
  local viable_left = true
  if self.action_delay_timer <= 0 then
    viable_left = self:do_random_action(current)
    self.action_delay_timer = action_delay
  end

  if not viable_left then
    self:getWorld():emit("take_turn_action", current, turn_actions.end_turn)
  end
end

return AiSystem
