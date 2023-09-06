FactoryBot.define do
  factory :kyc do
    user
    fullName { Faker::Name.name }
    birthday { Faker::Date.birthday(min_age: 18, max_age: 65) }
    address { Faker::Address.full_address }
    idType { "Driver's License" }
    idNumber { Faker::IDNumber.valid }
  end
end
