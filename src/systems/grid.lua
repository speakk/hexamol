local GridSystem = Concord.system({ })

function GridSystem.frame_start(_, dt)
  Gamestate.current().map:frameStart(dt)
end

return GridSystem
