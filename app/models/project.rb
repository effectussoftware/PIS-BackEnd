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
  validates :project_type, inclusion: { in: Project::PROJECT_TYPES }
  validates :project_state, inclusion: { in: Project::PROJECT_STATES }
  validates :name, :description, :start_date, project_type, project_state, presence: { message: "Mandatory field missing" }
  #validate :name_is_valid
  validate :name_validation
  validate :budget_is_valid
  validate :end_date_is_after_start_date
  validate :end_date_cannot_be_in_the_past

  private

  def name_validation
    name.downcase.gsub(/\s+/, "") != Project.find(:conditions => ['name LIKE ?', name]).downcase.gsub(/\s+/, "")
  end

=begin
  def name_is_valid
    :name, uniqueness: {
      case_sensitive: true,
      # object = project object being validated
      # data = { model: "Project", attribute: "Name", value: <name> }
      message: ->(data) do
        "A project with name: \"#{data[:value]}\" already exist. Please choose other."
      end
    }
    # habra que chequear que no tenga espacios o caracteres raros? Mas que anda para el uniqueness , que no sea
    # lo mismo "proyecto" que "proyecto "

  end
=end

  def budget_is_valid
    return if budget.blank?

    return unless budget < 0

    errors.add(:budget, 'cannot be a negative value')
  end

  def end_date_is_after_start_date
    return if end_date.blank? || start_date.blank?

    return unless end_date < start_date

    errors.add(:end_date, 'cannot be before the start time')
  end

  def end_date_cannot_be_in_the_past
    if end_date.present? && end_date < Date.today
      errors.add(:end_date, "can't be in the past")
    end
  end
end

