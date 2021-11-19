local CurrencySystem = Concord.system({})

function CurrencySystem:change_currency(options)
  local holds_currency = options.team.holds_currency
  assert(holds_currency.value + options.amount >= 0, "Tried to use more currency than available")

  holds_currency.value = holds_currency.value + options.amount

  self:getWorld():emit("currency_changed", options.team)
end

return CurrencySystem
