local GameOverSystem = Concord.system({})

function GameOverSystem:game_over(winning_team)
  states.in_game:game_over(winning_team)
end

return GameOverSystem
