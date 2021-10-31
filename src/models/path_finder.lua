local AStar = require 'libs.astar.astar'

local cache = {}

-- local getCacheKey = function(from, to, force_target_available)
-- 
-- end

local createNewFinder = function(gamestate_map, force_available_hexes)
  local map = {}

  -- Return all neighbor nodes. Means a target that can be moved from the current node
  function map.get_neighbors(_, hex, _)
    return gamestate_map:getHexNeighbors(hex, false, force_available_hexes)
  end

  -- Cost of two adjacent nodes.
  -- Distance, distance + cost or other comparison value you want
  function map.get_cost(_, _, _)
    return 1
    --return math.sqrt(math.pow(from_node.x - to_node.x, 2) + math.pow(from_node.y - to_node.y, 2))
  end

  -- For heuristic. Estimate cost of current node to goal node
  -- As close to the real cost as possible
  function map:estimate_cost(node, goal_node)
    return self:get_cost(node, goal_node)
  end

  return AStar.new(map)
end

local PathFinder = Class {
  init = function(self, gamestate_map)
    local map = {}

    -- Return all neighbor nodes. Means a target that can be moved from the current node
    function map.get_neighbors(_, hex, from_hex)
      return gamestate_map:getHexNeighbors(hex, false)
    end

    -- Cost of two adjacent nodes.
    -- Distance, distance + cost or other comparison value you want
    function map.get_cost(_, from_node, to_node)
      return 1
      --return math.sqrt(math.pow(from_node.x - to_node.x, 2) + math.pow(from_node.y - to_node.y, 2))
    end

    -- For heuristic. Estimate cost of current node to goal node
    -- As close to the real cost as possible
    function map:estimate_cost(node, goal_node)
      return self:get_cost(node, goal_node)
    end

    self.finder = AStar.new(map)
  end,

  find_path = function(self, from, to, force_available_hexes, exclude_last)
    --return self.finder:find(from, to)
    -- TODO: Cache!
    local finder = createNewFinder(states.in_game.map, force_available_hexes)
    local path = finder:find(from, to)
    if path then
      if exclude_last then
        table.remove(path)
      end
      return path
    end
  end
}

return PathFinder
