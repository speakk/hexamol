return {
  end_turn = {
    event_name = "end_turn",
  },
  place_character = {
    event_name = "place_character",
    currency_cost = 1
  },
  move_entity = {
    event_name = "move_entity",
    action_point_cost = 1
  },
  move_and_attack = {
    event_name = "move_and_attack",
    action_point_cost = 1
  },
  can_perform_action = function(action, options, world)
    if action.currency_cost then
      local holds_currency = options.team.holds_currency
      print("holds_currency", holds_currency.value, action.currency_cost)
      if holds_currency.value < action.currency_cost then
        world:emit("ran_out_of_currency", { team = options.team })
        return
      end
    end

    if action.action_point_cost then
      if options.unit.action_points.value < action.action_point_cost then
        world:emit("no_action_points_left_for_unit", { unit = options.unit })
        return
      end
    end

    return true
  end
}
