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
class PersonProject < ApplicationRecord
  belongs_to :person
  belongs_to :project

  ROL_TYPES = %w[developer pm tester architect analyst designer].freeze

  validates :person_id, :project_id, :rol, :working_hours, :working_hours_type,
            :start_date, :end_date, presence: true

  validates_uniqueness_of :person_id, scope: %i[project_id rol start_date end_date]
  validates :rol, inclusion: { in: PersonProject::ROL_TYPES }
end
