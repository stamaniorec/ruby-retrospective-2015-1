def convert_to_bgn(price, currency)
  rates = {
    usd: 1.7408,
    eur: 1.9557,
    gbp: 2.6415,
    bgn: 1.0
  }
  rate = rates[currency]
  (rate * price).round(2)
end

def compare_prices(price_a, currency_a, price_b, currency_b)
  convert_to_bgn(price_a, currency_a) <=> convert_to_bgn(price_b, currency_b)
end