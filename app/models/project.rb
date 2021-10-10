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
#  organization  :string
#
# Indexes
#
#  index_projects_on_name  (name) UNIQUE
#
class Project < ApplicationRecord
  has_many :user_projects, dependent: :destroy
  has_many :users, :through => :user_projects

  has_many :project_technologies, dependent: :destroy
  has_many :technologies, through: :project_technologies

  has_many :person_project, dependent: :destroy
  has_many :people, through: :person_project

  PROJECT_TYPES = %w[staff_augmentation end_to_end tercerizado].freeze
  PROJECT_STATES = %w[rojo amarillo verde upcomping].freeze
  validates :name, presence: { message: I18n.t('api.errors.project.missing_param',
                                               { value: :name }) }
  validates :description,
            presence: { message: I18n.t('api.errors.project.missing_param',
                                        { value: :description }) }
  validates :start_date,
            presence: { message: I18n.t('api.errors.project.missing_param',
                                        { value: :start_date }) }
  validates :project_type, inclusion: { in: Project::PROJECT_TYPES },
                           presence: { message: I18n.t('api.errors.project.missing_param',
                                                       { value: :project_type }) }
  validates :project_state, inclusion: { in: Project::PROJECT_STATES },
                            presence: { message: I18n.t('api.errors.project.missing_param',
                                                        { value: :project_state }) }
  validates :name, uniqueness: true
  validate :budget_is_valid
  validate :end_date_is_after_start_date

  after_update :update_person_projects

  def update_person_projects
    person_projects = PersonProject.where('project_id = :project_id
        AND start_date < :start_date', { project_id: id, start_date: start_date })
    update_person_project_date(person_projects, :start_date, start_date)

    person_projects = PersonProject.where('project_id = :project_id
      AND end_date > :end_date', { project_id: id, end_date: end_date })

    update_person_project_date(person_projects, :end_date, end_date)
  end

  def update_person_project_date(person_projects, date, update)
    person_projects.each do |p_p|
      p_p[date] = update
      p_p.save!
    end
  end

  def add_project_technologies(technologies)
    return if technologies.blank? || !technologies.is_a?(Array)

    res = ProjectTechnology.add_project_technologies(id, technologies)
    res.each { |p_t| project_technologies << p_t }
    res
  end

  def rebuild_project_technologies(technologies)
    project_technologies.destroy_all
    add_project_technologies(technologies)
  end

  private

  def budget_is_valid
    return if budget.blank?

    return unless budget.negative?

    errors.add(:budget, I18n.t('api.errors.project.invalid_budget'))
  end

  def end_date_is_after_start_date
    return if end_date.blank? || start_date.blank?

    return unless end_date < start_date

    errors.add(:end_date, I18n.t('api.errors.project.end_date_before_start_date'))
  end
end
