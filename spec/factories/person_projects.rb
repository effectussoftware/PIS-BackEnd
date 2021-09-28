# == Schema Information
#
# Table name: person_projects
#
#  id                 :bigint           not null, primary key
#  person_id          :bigint           not null
#  project_id         :bigint           not null
#  rol                :string
#  working_hours      :integer
#  working_hours_type :string
#  start_date         :date
#  end_date           :date
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_person_projects_on_person_id   (person_id)
#  index_person_projects_on_project_id  (project_id)
#
FactoryBot.define do
  factory :person_project do
    person { nil }
    project { nil }
    rol { "MyString" }
    working_hours { 1 }
    working_hours_type { "MyString" }
    start_date { "2021-09-28" }
    end_date { "2021-09-28" }
  end
end
