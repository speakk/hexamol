local Class = require 'libs.hump.class'

local hexagonSprite = "media/hexagon.png"
local spriteSize = 32
local tileSize = spriteSize / 2 * 1.1

local function Hex(q, r, world)
  return Concord.entity(world):give("coordinates", q, r)
end

local distanceCache = {}

local function createHexEntity(self, q, r, world)
  local x, y = self:getPixelCoordsFromHex(Hex(q, r))
  local hex = Hex(q, r, world)
  :give("sprite", hexagonSprite)
  :give("position", x, y)
  :give("origin", 0.5, 0.3)
  :give("layer", "map")
  :give("color")
  :give("hex")
  :give("position_delta")
  :ensure("key")

  return hex
end

local function axial_distance(a, b)
  local coordA = a.coordinates
  local coordB = b.coordinates
  return ( math.abs(coordA.q - coordB.q)
            + math.abs(coordA.q + coordA.r - coordB.q - coordB.r)
            + math.abs(coordA.r - coordB.r)) / 2
end

local function createGrid(self, radius, world, shape)
  local map = {}

  if not shape or shape == "hexagonal" then
    for q = -radius,radius do
      local r1 = math.max(-radius, -q - radius)
      local r2 = math.min(radius, -q + radius)
      for r = r1,r2 do
        local hex = createHexEntity(self, q, r, world)
        table.insert(map, hex)
      end
    end
  elseif shape == "square" then
    local top = math.floor(-radius/2)
    local left = math.floor(-radius/2)
    local bottom = math.floor(radius/2)
    local right = math.floor(radius/2)
    for r=top,bottom do
      local r_offset = math.floor(r/2)
      for q=left-r_offset,right-r_offset do
        local hex = createHexEntity(self, q, r, world)
        table.insert(map, hex)
      end
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
  init = function(self, x, y, radius, world, shape)
    self.x = x
    self.y = y
    self.hexSize = tileSize
    self.radius = radius
    self.shape = shape
    self.entities = {}
    self.world = world

    self.grid = {}
    self.gridHash = {}
  end,
  initialize_map_entities = function(self)
    createGrid(self, self.radius, self.world, self.shape)
    --self.grid = createGrid(self, self.radius, self.world, self.shape)
    -- for _, hex in ipairs(self.grid) do
    --   self.gridHash[coordinatesToIndex(hex.coordinates.q, hex.coordinates.r)] = hex
    -- end

    -- table.sort(self.grid, function(a, b)
    --   local x1, y1 = pointy_hex_to_pixel(a, tileSize, self.x, self.y)
    --   local x2, y2 = pointy_hex_to_pixel(b, tileSize, self.x, self.y)
    --   if y1 == y2 then return x1 < x2 end
    --   return y1 < y2
    -- end)
  end,
  addHexToMap = function(self, hex)
    self.gridHash[coordinatesToIndex(hex.coordinates.q, hex.coordinates.r)] = hex
    table.insert(self.grid, hex)
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

  getDistance = function(self, from, to)
    local distance = axial_distance(from, to)
    return distance
  end,

  __hexAdd = function(self, a, b)
    return Hex(a.coordinates.q + b.coordinates.q, a.coordinates.r + b.coordinates.r)
  end,

  __hexScale = function(self, hex, k)
    return Hex(hex.coordinates.q * k, hex.coordinates.r * k)
  end,

  __hexNeigbor = function(self, hex, direction)
    return self:__hexAdd(hex, neighbor_directions[direction])
  end,

  getHexRing = function(self, hex, radius)
    local hexes = {}
    local currentHex = self:__hexAdd(hex, self:__hexScale(neighbor_directions[5], radius))

    for i=1,6 do
      for j=0,radius-1 do
        table.insert(hexes, currentHex)
        if currentHex then
          currentHex = self:__hexNeigbor(currentHex, i)
        end
      end
    end

    local mapHexes = {}
    for _, hex in ipairs(hexes) do
      local mapHex = self:getHex(hex.coordinates.q, hex.coordinates.r)
      if mapHex then
        table.insert(mapHexes, mapHex)
      end
    end

    return mapHexes
  end,

  getHexesInRadius = function(self, hex, radius)
    local hexes = {}
    for i=1,radius do
      local ringHexes = self:getHexRing(hex, i)
      for _, ringHex in ipairs(ringHexes) do
        table.insert(hexes, ringHex)
      end
    end

    return hexes
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
    local origin_hex = self:getHex(0,0)
    for _, hex in ipairs(self.grid) do
      local distance
      if distanceCache[hex] then
        distance = distanceCache[hex]
      else
        distance = self:getDistance(origin_hex, hex)
        if self.shape == "square" then
          distance = distance*4
        end
        distanceCache[hex] = distance
      end

      local fadedColor = 1 - (distance/self.radius)*0.3
      local destR, destG, destB = fadedColor, fadedColor, fadedColor
      local spawnHexTeam = hex.spawn_hex and hex.spawn_hex:fetch(self.world)
      if spawnHexTeam then
        --print("spawnHex", spawnHex, spawnHex.team.name)
        -- XXX: SERIALIZE REFACTOR TODO, this probably did stuff
        local color = spawnHexTeam.color
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
