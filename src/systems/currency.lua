local CurrencySystem = Concord.system({})

function CurrencySystem.use_currency(_, options)
  assert(options.team.holds_currency.value >= options.amount, "Tried to use more currency than available")

  options.team.holds_currency.value = options.team.holds_currency.value - options.amount
end

return CurrencySystem
