local AStar = require 'libs.astar.astar'


-- Node must be able to check if they are the same
-- Cannot directly return different tables for the same coord
-- The library doesn't change nodes, so you able to reuse your node or create a C struct for faster
local function get_node(x, y)
  local row = cached_nodes[y]
  if not row then
    row = {}
    cached_nodes[y] = row
  end
  local node = row[x]
  if not node then
    node = { x = x, y = y }
    row[x] = node end
  return node
end

local PathFinder = Class {
  init = function(self, gamestate_map)
    local map = {}
    local cached_nodes = {}

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

  find_path = function(self, from, to)
    local path = self.finder:find(from, to)

    if path then
      return path
    else
      print("Not found path")
    end
  end
}

return PathFinder
