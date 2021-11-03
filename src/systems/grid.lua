local GridSystem = Concord.system({ })

function GridSystem.frame_start()
  states.in_game.map:frameStart()
end

return GridSystem
