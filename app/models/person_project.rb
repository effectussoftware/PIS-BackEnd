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
class PersonProject < ApplicationRecord
  belongs_to :person
  belongs_to :project
  FILTER_PARAMS = Project::FILTER_PARAMS
  ARRAY_FILTER_PARAMS = Project::ARRAY_FILTER_PARAMS

  delegate :first_name, to: :person, prefix: true
  delegate :name, to: :project, prefix: true

  validate :uniqueness_of_role_for_person
  validates :person_id, :project_id, :role, :working_hours, :working_hours_type,
            :start_date, presence: true

  validates :role, inclusion: { in: Person::ROL_TYPES }

  validate :end_date_is_after_start_date
  validate :dates_between_project_dates

  before_validation :set_end_date
  before_save :update_person_roles

  private

  def dates_between_project_dates
    project = Project.find(project_id)
    check_with_project_start_date(project.start_date)
    check_with_project_end_date(project.end_date)
  end

  def check_with_project_end_date(p_end_date)
    return if p_end_date.blank?
    return if end_date.present? && p_end_date >= end_date

    errors.add(:end_date,
               I18n.t('api.errors.person_project.end_date_after_project',
                      { project_end_date: p_end_date }))
  end

  def check_with_project_start_date(p_start_date)
    return if start_date.present? && (p_start_date <= start_date)

    errors.add(:start_date,
               I18n.t('api.errors.person_project.start_date_before_project',
                      { project_start_date: p_start_date }))
  end

  def update_person_roles
    person = Person.find(person_id)
    person_roles = person.roles
    return if person_roles.include?(role)

    person_roles << role
    person.save!
  end

  def end_date_is_after_start_date
    return if end_date.blank? || start_date.blank?

    return unless end_date < start_date

    errors.add(:end_date, I18n.t('api.errors.project.end_date_before_start_date'))
  end

  def uniqueness_of_role_for_person
    return unless PersonProject.exists? person_id: person_id, project_id: project_id,
                                    role: role, start_date: start_date, end_date: end_date

    errors.add(:person_id, I18n.t('api.errors.person_project.already_added',
                                  { role: role, person: person.full_name } ))
  end

  def set_end_date
    self.end_date = Project.find(project_id).end_date if end_date.blank?
  end
end
