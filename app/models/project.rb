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
# Indexes
#
#  index_projects_on_name  (name) UNIQUE
#
class Project < ApplicationRecord
  has_many :project_technologies, dependent: :destroy
  has_many :technologies, through: :project_technologies

  PROJECT_TYPES = %w[staff_augmentation end_to_end tercerizado].freeze
  PROJECT_STATES = %w[rojo amarillo verde upcomping].freeze
  validates :name, :description, :start_date, :project_type, :project_state,
            presence: { message: 'Mandatory field missing' }
  validates :project_type, inclusion: { in: Project::PROJECT_TYPES }
  validates :project_state, inclusion: { in: Project::PROJECT_STATES }
  validates :name, uniqueness: true
  validate :budget_is_valid
  validate :end_date_is_after_start_date

  private

  def budget_is_valid
    return if budget.blank?

    return unless budget.negative?

    errors.add(:budget, 'cannot be a negative value')
  end

  def end_date_is_after_start_date
    return if end_date.blank? || start_date.blank?

    return unless end_date < start_date

    errors.add(:end_date, 'cannot be before the start time')
  end


  def add_technology(technology)
    project_technology = self.project_technologies.find_by technology_id: technology.id
    if project_technology.blank?
      project_technology = self.project_technologies.create(person_id: id, technology_id: technology.id)
    end
    project_technology
  end
end
