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
    description { Faker::Lorem.sentence(word_count: 3) }
    start_date { Faker::Date.between(from: '2025-09-23', to: '2025-09-25') }
    end_date { Faker::Date.between(from: '2030-10-23', to: '2030-10-25') }
    budget { 1 }
    project_type  { Project::PROJECT_TYPES.sample }
    project_state { Project::PROJECT_STATES.sample }
  end
end
