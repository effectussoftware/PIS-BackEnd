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
#  index_person_project                 (person_id,project_id,rol,start_date,end_date) UNIQUE
#  index_person_projects_on_person_id   (person_id)
#  index_person_projects_on_project_id  (project_id)
#
class PersonProject < ApplicationRecord
  belongs_to :person
  belongs_to :project

  delegate :first_name, to: :person, prefix: true
  delegate :name, to: :project, prefix: true

  validates :person_id, :project_id, :rol, :working_hours, :working_hours_type,
            :start_date, presence: true

  validates :person_id, uniqueness: { scope: %i[project_id rol start_date end_date] }
  validates :rol, inclusion: { in: Person::ROL_TYPES }
  validate :end_date_is_after_start_date

  before_validation :set_end_date

  private

  def end_date_is_after_start_date
    return if end_date.blank? || start_date.blank?

    return unless end_date < start_date

    errors.add(:end_date, I18n.t('api.errors.end_date_before_start_date'))
  end

  def set_end_date
    self.end_date = Project.find(project_id).end_date if end_date.blank?
  end
end
