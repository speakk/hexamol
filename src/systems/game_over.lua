local GameOverSystem = Concord.system({})

function GameOverSystem:game_over(player_won)
  states.in_game:game_over(player_won)
end

return GameOverSystem
