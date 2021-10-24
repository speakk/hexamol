local Class = require 'libs.hump.class'

local hexagonSprite = love.graphics.newImage("media/hexagon.png")
local spriteSize = 32
local tileSize = spriteSize / 2 * 1.1

local hexTile = Class {
  init = function(self, q, r)
    -- q: column, r: row
    self.q = q
    self.r = r
    self.s = -q-r
  end
}

local function createGrid(radius)
  local map = {}
  for q = -radius,radius do
    local r1 = math.max(-radius, -q - radius)
    local r2 = math.min(radius, -q + radius)
    for r = r1,r2 do
      table.insert(map, hexTile(q, r))
    end
  end

  return map
end

local sqrt3 = math.sqrt(3)

-- This is to make it "prettier" as the sprites should overlap a bit as there is perspective built in to the sprite
local verticalOffset = 4

-- luacheck: ignore
local function flat_hex_to_pixel(hex, hexSize)
  local x = hexSize * (3/2 * hex.q)
  local y = hexSize * (sqrt3/2 * hex.q + sqrt3 * hex.r) * (hexSize / (hexSize + verticalOffset))

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
  --local hexSizeY = hexSize - verticalOffset

  -- local x = hexSizeX * (sqrt3 * hex.q + sqrt3/2 * hex.r)
  -- local y = hexSizeY * (3/2 * hex.r)

  -- double x = (M.f0 * h.q + M.f1 * h.r) * layout.size.x;
  -- double y = (M.f2 * h.q + M.f3 * h.r) * layout.size.y;
  local x = (matrix.f0 * hex.q + matrix.f1 * hex.r) * layout_size_x
  local y = (matrix.f2 * hex.q + matrix.f3 * hex.r) * layout_size_y

  return x + originX, y + originY
end


local function pixel_to_pointy_hex(x, y, hexSize, originX, originY)
  -- local hexSizeX = hexSize
  -- --local hexSizeY = hexSize - verticalOffset
  -- local hexSizeY = hexSize

  -- local q = (sqrt3/3 * x - 1/3 * y) / hexSizeX
  -- local r = (2/3 * y) / hexSizeY

  -- return hex_round(q, r)

  local finalX = (x - originX) / layout_size_x
  local finalY = (y - originY) / layout_size_y
  local q = matrix.b0 * finalX + matrix.b1 * finalY
  local r = matrix.b2 * finalX + matrix.b3 * finalY

  return hex_round(q, r)
end


local Map = Class {
  init = function(self, x, y, radius)
    self.grid = createGrid(radius)
    self.x = x
    self.y = y
    self.hexSize = tileSize

    table.sort(self.grid, function(a, b)
      local x1, y1 = pointy_hex_to_pixel(a, tileSize, self.x, self.y)
      local x2, y2 = pointy_hex_to_pixel(b, tileSize, self.x, self.y)
      if y1 == y2 then return x1 < x2 end
      return y1 < y2
    end)

  end,

  draw = function(self)
    for _, tile in ipairs(self.grid) do
      local x,y = pointy_hex_to_pixel(tile, self.hexSize, self.x, self.y)
      if tile.selected then
        love.graphics.setColor(1,0.2,0.8)
        y = y - 4
      end
      love.graphics.draw(hexagonSprite, math.floor(x), math.floor(y), 0, 1, 1, spriteSize/2, spriteSize/2)
      love.graphics.setColor(1,1,1)
    end
  end,

  getHexFromPixelCoords = function(self, x, y)
    if not x or not y then return nil end
    local q, r = pixel_to_pointy_hex(x, y, self.hexSize, self.x, self.y)
    --print("q, r", q, r)
    -- TODO: Save the grid also as a simple [q+r] hash table so we can avoid this silly looping
    for _, hex in ipairs(self.grid) do
      if q == hex.q and r == hex.r then
        return hex
      end
    end
  end,

  update = function(self)
    for _, hex in ipairs(self.grid) do
      hex.selected = false
    end
  end
}

return Map
