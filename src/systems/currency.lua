local CurrencySystem = Concord.system({})

function CurrencySystem:use_currency(options)
  assert(options.team.holds_currency.value >= options.amount, "Tried to use more currency than available")

  options.team.holds_currency.value = options.team.holds_currency.value - options.amount

  self:getWorld():emit("currency_changed", options.team)
end

return CurrencySystem
