FactoryBot.define do
    factory :transaction do
      transaction_type { ['buy', 'sell'].sample }
      transaction_amount { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
      transaction_price { Faker::Number.decimal(l_digits: 3, r_digits: 2) }
      usd_value { Faker::Number.decimal(l_digits: 4, r_digits: 2) }
      user
      token
    end
  end
  