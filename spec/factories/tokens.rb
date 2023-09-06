FactoryBot.define do
    factory :token do
      ticker { Faker::CryptoCoin.acronym }
      name { Faker::CryptoCoin.name }
      price { Faker::Number.decimal(l_digits: 3, r_digits: 2) }
      external_id { SecureRandom.uuid }
    end
  end
  