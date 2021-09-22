# == Schema Information
#
# Table name: people
#
#  id                :bigint           not null, primary key
#  first_name        :string           not null
#  last_name         :string           not null
#  email             :string
#  hourly_load       :string
#  hourly_load_hours :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_people_on_email  (email) UNIQUE
#
FactoryBot.define do
  factory :person do
    first_name { Faker::Name.unique.name }
    last_name { Faker::Name.unique.last_name }
    email { Faker::Internet.unique.email }
    hourly_load { 'weekly' }
    hourly_load_hours { 36 }
  end
end
