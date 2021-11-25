local UICurrencySystem = Concord.system({ current_turn = { "current_turn", "team" }, player_controlled = { "player_controlled", "team" }})

function UICurrencySystem:init(world)
  self.ui_entity = Concord.entity(world)
  :give("ui", {
    element = require 'ui.currency'(),
    active = true
  })
  :remove("serializable")
end

function UICurrencySystem:turn_starts(team)
  self.ui_entity.ui.element.children.gold_count.text = "" .. team.holds_currency.value
end

function UICurrencySystem:game_loaded()
  self.ui_entity.ui.element.children.gold_count.text = "" .. self.current_turn[1].holds_currency.value
end

function UICurrencySystem:currency_changed(entity)
  local current_team = self.current_turn[1]
  if current_team ~= entity then return end

  self.ui_entity.ui.element.children.gold_count.text = "" .. entity.holds_currency.value
end

return UICurrencySystem
