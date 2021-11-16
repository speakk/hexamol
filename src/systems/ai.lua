local turn_actions = require 'models.turn_actions'
local AiSystem = Concord.system({
  ai_teams = { "team", "ai_controlled" },
  in_team = { "is_in_team", "can_be_moved" },
  bases = { "base" },
  current = { "current_turn", "team", "ai_controlled" },
  spawn_hexes = { "spawn_hex" },
  all_in_map = { "is_in_hex" }
})

function AiSystem:getFreeSpawnHex(team)
  local teamHexes = functional.filter(self.spawn_hexes, function(hex)
    return hex.spawn_hex.team == team
  end)

  return table.pick_random(teamHexes)
end

function AiSystem:getTeamEntities(team)
  return functional.filter(self.in_team, function(entity)
    if entity.is_in_team.teamEntity == team then
      return true
    end
  end)
end

function AiSystem.init()
end

local action_delay = 1

function AiSystem:run_ai_turn(teamEntity)
  self.action_delay_timer = action_delay
  print("run_ai_turn", action_delay)
end

local actions = {
  {
    -- Random move
    isViable = function(self, team)
      local aiEntities = self:getTeamEntities(team)
      if not aiEntities or #aiEntities == 0 then
        return false
      end

      return aiEntities
    end,
    run = function(self, team, aiEntities)
      assert(aiEntities)
      local randomEntity = table.pick_random(aiEntities)
      local newRandomHex = states.in_game.map:getRandomFreeHex()
      if (newRandomHex) then
        self:getWorld():emit("take_turn_action", team,
        turn_actions.move_entities,
        {
          target_hex = newRandomHex,
          entities = { randomEntity }
        }
        )
      end
    end,
    total_action_points = turn_actions.move_entities.action_points,
    weight = 1
  },
  {
    -- Random place
    isViable = function(self, team)
      return self:getFreeSpawnHex(team)
      --return states.in_game.map:getRandomFreeHex()
    end,
    run = function(self, team, randomHex)
      assert(randomHex)
      self:getWorld():emit("take_turn_action", team,
        turn_actions.place_character,
        {
          target_hex = randomHex,
          team = team
        }
      )
    end,
    total_action_points = turn_actions.place_character.action_points,
    weight = 1
  },
  {
    -- Random attack
    isViable = function(self, team)
      local aiEntities = self:getTeamEntities(team)
      if not aiEntities or #aiEntities == 0 then return false end

      local enemies = functional.filter(self.all_in_map, function(entity)
        return entity.is_in_team.teamEntity ~= team
      end)

      local enemiesInRangeMap = {}

      local has_enemy_in_range = functional.filter(aiEntities, function(entity)
        local enemies_in_range = functional.filter(enemies, function(enemy)
          local is_in_range = Gamestate.current().map:getDistance(entity.is_in_hex.hex, enemy.is_in_hex.hex)
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
          by = random_entity,
          against = random_enemy
        }
      )
    end,
    total_action_points = turn_actions.move_and_attack.action_points,
    weight = 1
  },
  {
    -- Attack base
    isViable = function(self, team)
      local enemy_base = functional.find_match(self.bases, function(base)
        return base.is_in_team.teamEntity ~= team
      end)

      local aiEntities = self:getTeamEntities(team)
      if not aiEntities or #aiEntities == 0 then return false end
      local within_distance = functional.filter(aiEntities, function(entity)
        return Gamestate.current().map:getDistance(entity.is_in_hex.hex, enemy_base.is_in_hex.hex) <= entity.movement_range.value
      end)
      if not within_distance or #within_distance == 0 then return false end
      local random_entity = table.pick_random(within_distance)

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
          by = data.random_entity,
          against = data.enemy_base
        }
      )
    end,
    total_action_points = turn_actions.move_and_attack.action_points,
    weight = 3
  }
}

local function weighted_random(weights)
    local sum = 0
    for _, weight in ipairs (weights) do
        sum = sum + weight
    end
    if sum == 0 then return end
    local value = math.random (sum)
    sum = 0
    for i, weight in ipairs (weights) do
        sum = sum + weight
        if value <= sum then
            return i, weight
        end
    end
end


function AiSystem:do_random_action(team)
  local action_datas = {}
  local viable_actions = functional.filter(actions, function(action)
    if action.total_action_points > team.action_points.value then
      return false
    end

    local action_data = action.isViable(self, team)
    if action_data then
      action_datas[action] = action_data
      return true
    end
  end)

  if #viable_actions == 0 then return false end

  local weights = functional.map(viable_actions, function(action) return action.weight end)
  local weightedIndex, _ = weighted_random(weights)

  local action = viable_actions[weightedIndex]
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

  if current.action_points.value <= 0 or not viable_left then
    self:getWorld():emit("take_turn_action", current, turn_actions.end_turn)
  end
end

return AiSystem
