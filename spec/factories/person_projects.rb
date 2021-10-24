# == Schema Information
#
# Table name: person_projects
#
#  id                 :bigint           not null, primary key
#  person_id          :bigint           not null
#  project_id         :bigint           not null
#  role               :string
#  working_hours      :integer
#  working_hours_type :string
#  start_date         :date
#  end_date           :date
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_person_project                 (person_id,project_id,role,start_date,end_date) UNIQUE
#  index_person_projects_on_person_id   (person_id)
#  index_person_projects_on_project_id  (project_id)
#
FactoryBot.define do
  factory :person_project do
    person { 1 }
    project { 1 }
    role { 'developer' }
    working_hours { 3 }
    working_hours_type { 'daily' }
    start_date { '2025-09-23' }
    end_date { '2030-10-25' }
  end
end
