FactoryBot.define do
    factory :portfolio_item do
      amount { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
      user
      token
    end
  end