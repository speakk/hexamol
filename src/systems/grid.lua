local GridSystem = Concord.system({})

local Map = require 'models.map'

function GridSystem:init()
  self.map = Map(200, 200, 6)
end

function GridSystem:draw()
  self.map:draw()
end

return GridSystem
