local GridSystem = Concord.system({ hex = { 'hex' } })

function GridSystem:init(world)
  self.hex.onAdded = function(_, entity)
    world:getResource("map"):addHexToMap(entity)
  end
end

function GridSystem:frame_start(dt)
  self:getWorld():getResource("map"):frameStart(dt)
end

function GridSystem:initialize_map_entities()
  self:getWorld():getResource("map"):initialize_map_entities()
end

return GridSystem
