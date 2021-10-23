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

local function pixel_to_pointy_hex(x, y, hexSize)
  local q = (sqrt3/3*x - 1/3 * y) / hexSize
  local r = (2/3 * y) / hexSize

  return q,r
end

local function pointy_hex_to_pixel(hex, hexSize)
  local x = hexSize * (sqrt3 * hex.q + sqrt3/2 * hex.r)
  local y = hexSize * (3/2 * hex.r) * (hexSize / (hexSize + verticalOffset))

  return x,y
end



local Map = Class {
  init = function(self, x, y, radius)
    self.grid = createGrid(radius)
    table.sort(self.grid, function(a, b)
      local _, y1 = pointy_hex_to_pixel(a, tileSize)
      local _, y2 = pointy_hex_to_pixel(b, tileSize)
      return y1 < y2
    end)

    self.x = x
    self.y = y
    self.hexSize = tileSize
  end,

  draw = function(self)
    for _, tile in ipairs(self.grid) do
      local x,y = pointy_hex_to_pixel(tile, self.hexSize)
      love.graphics.draw(hexagonSprite, x + self.x, y + self.y)
    end
  end,

  getHexFromPixelCoords = function(self, x, y)
    local q, r = pixel_to_pointy_hex(x, y, self.hexSize)
    -- TODO: Save the grid also as a simple [q+r] hash table so we can avoid this silly looping
    for _, hex in ipairs(self.grid) do
      if q == hex.q and r == hex.r then
        return hex
      end
    end
  end
}

return Map
