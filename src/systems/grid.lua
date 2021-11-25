local GridSystem = Concord.system({ hex = { 'hex' } })

function GridSystem:init(_)
  self.hex.onAdded = function(_, entity)
    Gamestate.current().map:addHexToMap(entity)
  end
end

function GridSystem.frame_start(_, dt)
  Gamestate.current().map:frameStart(dt)
end

function GridSystem.initialize_map_entities()
  Gamestate.current().map:initialize_map_entities()
end

return GridSystem
