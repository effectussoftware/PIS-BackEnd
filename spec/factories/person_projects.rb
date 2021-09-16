# == Schema Information
#
# Table name: person_projects
#
#  id         :bigint           not null, primary key
#  person_id  :integer          not null
#  project_id :integer          not null
#  rol        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_person_projects_on_person_id_and_project_id  (person_id,project_id) UNIQUE
#
FactoryBot.define do
  factory :person_project do
    person_id { 1 }
    project_id { 1 }
    rol { "MyString" }
  end
end
