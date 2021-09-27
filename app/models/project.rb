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
class Project < ApplicationRecord
  PROJECT_TYPES = %w[staff_augmentation end_to_end tercerizado].freeze
  PROJECT_STATES = %w[rojo amarillo verde upcomping].freeze
  validates :name, :description, :start_date, :project_type, :project_state,
            presence: { message: 'Mandatory field missing' }
  validates :project_type, inclusion: { in: Project::PROJECT_TYPES }
  validates :project_state, inclusion: { in: Project::PROJECT_STATES }
  validate :name_validation
  validate :budget_is_valid
  validate :end_date_is_after_start_date

  private

  def name_validation
    return if Project.where("replace(lower(name), ' ', '') like ?",
                            name.downcase.gsub(/\s+/, '')).blank?

    errors.add(:name, 'already exists')
  end

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

  #   TODO Revisar - creo que la fecha de end puede ser en el pasado
  #   validate :end_date_cannot_be_in_the_past
  #   def end_date_cannot_be_in_the_past
  #     if end_date.present? && end_date < Date.today
  #       errors.add(:end_date, "can't be in the past")
  #     end
  #   end
end
