FactoryBot.define do
  factory :person do
    first_name { Faker::Name.unique.name }
    last_name { Faker::Name.unique.last_name }
    email { Faker::Internet.unique.email }
    hourly_load { 1 }
    hourly_load_hours { 6 }
  end
end
