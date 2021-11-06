local Class = require 'libs.hump.class'

local hexagonSprite = love.graphics.newImage("media/hexagon.png")
local spriteSize = 32
local tileSize = spriteSize / 2 * 1.1

local function Hex(q, r)
  return Concord.entity():give("coordinates", q, r)
end

local function createGrid(self, radius, world)
  local map = {}
  for q = -radius,radius do
    local r1 = math.max(-radius, -q - radius)
    local r2 = math.min(radius, -q + radius)
    for r = r1,r2 do
      local x, y = self:getPixelCoordsFromHex(Hex(q, r))
      local hex = Hex(q, r)
        :give("sprite", hexagonSprite)
        :give("position", x, y)
        :give("layer", "map")
        :give("color")
        :give("position_delta")
      world:addEntity(hex)
      table.insert(map, hex)
    end
  end

  return map
end

local function reflectR(hex)
  --local q = hex.coordinates.q
  local r = hex.coordinates.r
  local s = -hex.coordinates.q-hex.coordinates.r
  return Hex(s, r)
end

local function reflectUp(hex)
  local q = hex.coordinates.q
  local r = hex.coordinates.r
  --local s = -hex.coordinates.q-hex.coordinates.r
  return Hex(-q, -r)
end

local neighbor_directions = {
  Hex(1, 0), Hex(1, -1), Hex(0, -1),
  Hex(-1, 0), Hex(-1, 1), Hex(0, 1),
}

local sqrt3 = math.sqrt(3)

-- This is to make it "prettier" as the sprites should overlap a bit as there is perspective built in to the sprite
local verticalOffset = 4

-- luacheck: ignore
local function flat_hex_to_pixel(hex, hexSize)
  local x = hexSize * (3/2 * hex.coordinates.q)
  local y = hexSize * (sqrt3/2 * hex.coordinates.q + sqrt3 * hex.coordinates.r) * (hexSize / (hexSize + verticalOffset))

  return x,y
end

local function hex_round(q, r)
  local s = -q -r

  local round_q = math.round(q)
  local round_r = math.round(r)
  local round_s = math.round(s)

  local q_diff = math.abs(round_q - q)
  local r_diff = math.abs(round_r - r)
  local s_diff = math.abs(round_s - s)

  if (q_diff > r_diff and q_diff > s_diff) then
    round_q = -round_r - round_s
  elseif (r_diff > s_diff) then
    round_r = -round_q - round_s
  else
    round_s = -round_q - round_r
  end

  return round_q, round_r, round_s
end

-- const double f0, f1, f2, f3;
--     const double b0, b1, b2, b3;
--     const double start_angle; // in multiples of 60°
-- const Orientation layout_pointy
--   = Orientation(sqrt(3.0), sqrt(3.0) / 2.0, 0.0, 3.0 / 2.0,
--                 sqrt(3.0) / 3.0, -1.0 / 3.0, 0.0, 2.0 / 3.0,
--                 0.5);
-- 

local pointy_matrix = {
  f0 = math.sqrt(3),
  f1 = math.sqrt(3) / 2,
  f2 = 0,
  f3 = 3 / 2,
  b0 = math.sqrt(3) / 3,
  b1 = -1 / 3,
  b2 = 0,
  b3 = 2 /3
}

local matrix = pointy_matrix

local layout_size_x = tileSize
local layout_size_y = tileSize - 5

local function pointy_hex_to_pixel(hex, hexSize, originX, originY)
  local hexSizeX = hexSize
  local hexSizeY = hexSize

  local x = (matrix.f0 * hex.coordinates.q + matrix.f1 * hex.coordinates.r) * layout_size_x
  local y = (matrix.f2 * hex.coordinates.q + matrix.f3 * hex.coordinates.r) * layout_size_y

  return x + originX, y + originY
end


local function pixel_to_pointy_hex(x, y, hexSize, originX, originY)
  local finalX = (x - originX) / layout_size_x
  local finalY = (y - originY) / layout_size_y
  local q = matrix.b0 * finalX + matrix.b1 * finalY
  local r = matrix.b2 * finalX + matrix.b3 * finalY

  return hex_round(q, r)
end

local function coordinatesToIndex(q, r)
  return q*1000 + r
end

local function indexToCoordinates(index)
  local q = math.floor(index/1000)
  local r = index - q * 1000

  return q, r
end

local Map = Class {
  init = function(self, x, y, radius, world)
    self.x = x
    self.y = y
    self.hexSize = tileSize
    self.grid = createGrid(self, radius, world)
    self.entities = {}

    self.gridHash = {}

    for _, hex in ipairs(self.grid) do
      self.gridHash[coordinatesToIndex(hex.coordinates.q, hex.coordinates.r)] = hex
    end

    table.sort(self.grid, function(a, b)
      local x1, y1 = pointy_hex_to_pixel(a, tileSize, self.x, self.y)
      local x2, y2 = pointy_hex_to_pixel(b, tileSize, self.x, self.y)
      if y1 == y2 then return x1 < x2 end
      return y1 < y2
    end)

  end,

  getHexFromPixelCoords = function(self, x, y)
    if not x or not y then return nil end
    local q, r = pixel_to_pointy_hex(x, y, self.hexSize, self.x, self.y)
    return self:getHex(q,r)
  end,

  getPixelCoordsFromHex = function(self, hex)
    local x1, y1 = pointy_hex_to_pixel(hex, self.hexSize, self.x, self.y)
    return x1, y1
  end,

  getHex = function(self, q, r)
    return self.gridHash[coordinatesToIndex(q, r)]
  end,

  addEntityToHex = function(self, entity, hex)
    self.entities[coordinatesToIndex(hex.coordinates.q, hex.coordinates.r)] = entity
  end,

  removeEntityFromHex = function(self, hex)
    self.entities[coordinatesToIndex(hex.coordinates.q, hex.coordinates.r)] = nil
  end,

  getRandomFreeHex = function(self)
    local shuffledHexes = table.shuffle(table.copy(self.grid))
    for _, hex in ipairs(shuffledHexes) do
      local isHexOccupied = self:getHexOccupants(hex)
      if not isHexOccupied then return hex end
    end
  end,

  getHexOccupants = function(self, hex)
    return self.entities[coordinatesToIndex(hex.coordinates.q, hex.coordinates.r)]
  end,

  reflectHexR = reflectR,
  reflectHexUp = reflectUp,

  getHexNeighbors = function(self, hex, include_occupied, force_available_hexes)
    local neighbors = {}
    for _, direction in ipairs(neighbor_directions) do
      local neighborHex = self:getHex(hex.coordinates.q + direction.coordinates.q, hex.coordinates.r + direction.coordinates.r)
      if neighborHex then
        local isHexOccupied = self:getHexOccupants(neighborHex)
        if force_available_hexes then
          for _, forceHex in ipairs(force_available_hexes) do
            if neighborHex == forceHex then isHexOccupied = false end
          end
        end
        --if isHexOccupied then print("hex was occupied") end
        if include_occupied or not isHexOccupied then
          table.insert(neighbors, neighborHex)
        end
      end
    end

    return neighbors
  end,

  update = function(self)
  end,

  frameStart = function(self, dt)
    -- TODO Move the hex coloring somewhere else? Getting pretty crowded in here...
    local color_change_speed = 3.4
    local position_change_speed = 0.4
    for _, hex in ipairs(self.grid) do
      local destR, destG, destB = 1,1,1
      local spawnHex = hex.spawn_hex
      if spawnHex then
        local color = spawnHex.team.color
        destR, destG, destB = color.r, color.g, color.b
      end
      hex.color.r = math.min(hex.color.r + (color_change_speed * dt), destR)
      hex.color.g = math.min(hex.color.g + (color_change_speed*0.6 * dt), destG)
      hex.color.b = math.min(hex.color.b + (color_change_speed * dt), destB)

      hex.position_delta.y = math.max(hex.position_delta.y - (position_change_speed * dt), 0)
    end

    if (self.last_found_path) then
      for _, hex in ipairs(self.last_found_path) do
        hex.color.r = 0.5
      end
    end

    if self.last_hovered_hex then
      self.last_hovered_hex.color.g = 0.5
      self.last_hovered_hex.position_delta.y = -5
    end
  end,

  setLastFoundPath = function(self, path)
    self.last_found_path = path
  end
}

return Map
