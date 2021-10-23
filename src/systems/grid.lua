local GridSystem = Concord.system({})
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

local function flat_hex_to_pixel(hex, hexSize)
  local x = hexSize * (3/2 * hex.q)
  local y = hexSize * (sqrt3/2 * hex.q + sqrt3 * hex.r) * (hexSize / (hexSize + verticalOffset))

  return x,y
end

local function pointy_hex_to_pixel(hex, hexSize)
  local x = hexSize * (sqrt3 * hex.q + sqrt3/2 * hex.r)
  local y = hexSize * (3/2 * hex.r) * (hexSize / (hexSize + verticalOffset))

  return x,y
end

local Map = Class {
  init = function(self, x, y, radius, _tileSize)
    self.grid = createGrid(radius)
    table.sort(self.grid, function(a, b)
      local _, y1 = pointy_hex_to_pixel(a, _tileSize)
      local _, y2 = pointy_hex_to_pixel(b, _tileSize)
      return y1 < y2
    end)

    self.x = x
    self.y = y
    self.hexSize = _tileSize
  end,

  draw = function(self)
    for _, tile in ipairs(self.grid) do
      local x,y = pointy_hex_to_pixel(tile, self.hexSize)
      love.graphics.draw(hexagonSprite, x + self.x, y + self.y)
    end
  end
}


function GridSystem:init()
  self.map = Map(200, 200, 6, tileSize)
end

function GridSystem:draw()
  self.map:draw()
end

return GridSystem
