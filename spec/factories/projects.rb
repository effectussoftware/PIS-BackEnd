# == Schema Information
#
# Table name: projects
#
#  id            :bigint           not null, primary key
#  name          :string           not null
#  description   :string           not null
#  start_date    :date             not null
#  end_date      :date
#  budget        :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  project_state :string           not null
#  project_type  :string           not null
#
FactoryBot.define do
  factory :project do
    name { Faker::Name.unique.name }
    description { Faker::Lorem.sentence(word_count: 5)}
    start_date { Faker::Date.between(from: '2025-01-01', to: '2025-12-31') }
    end_date { Faker::Date.between(from: '2030-01-01', to: '2030-12-31') }
    budget { rand(0..3000) }
    project_type  { PROJECT_TYPES[rand(0..2)] }
    project_state { PROJECT_STATES[rand(0..3)] }
  end
end