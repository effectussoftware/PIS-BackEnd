# == Schema Information
#
# Table name: people
#
#  id            :bigint           not null, primary key
#  first_name    :string           not null
#  last_name     :string           not null
#  email         :string
#  working_hours :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  roles         :text             default([]), is an Array
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
    working_hours { 36 }
    roles { %w[developer pm] }
  end
end
