local GridSystem = Concord.system({ })

function GridSystem.frame_start(_, dt)
  states.in_game.map:frameStart(dt)
end

return GridSystem
