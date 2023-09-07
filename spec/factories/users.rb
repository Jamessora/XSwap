FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { 'password123' }
    password_confirmation { 'password123' }


    trait :confirmed do
      confirmed_at { Time.now }
    end

    trait :with_kyc do
      after(:create) do |user|
        create(:kyc, user: user)
      end
    end
  end
end