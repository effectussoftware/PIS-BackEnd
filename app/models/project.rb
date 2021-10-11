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
  has_many :user_projects, dependent: :destroy
  has_many :users, :through => :user_projects

  PROJECT_TYPES = %w[staff_augmentation end_to_end tercerizado].freeze
  PROJECT_STATES = %w[rojo amarillo verde upcomping].freeze

  validates :name, :description, :start_date, :project_type, :project_state,
            presence: { message: 'Mandatory field missing' }
  validates :project_type, inclusion: { in: Project::PROJECT_TYPES }
  validates :project_state, inclusion: { in: Project::PROJECT_STATES }
  validates :name, uniqueness: true
  validate :budget_is_valid
  validate :end_date_is_after_start_date

=begin
    Para cada alerta hago lo siguiente:
    Si ya falta menos de 7 dias, la alerta ya esta activa y no se actualiza (solo se notifica si corresponde)
    Si faltan 7 dias o mas se debe verificar que la alerta este en estado correcto, se ejecuta actualizar_estado
=end
  def check_alerts
    actual_date = DateTime.new.to_date
    return if end_date.blank?
    days_difference = (end_date - actual_date)
    user_projects.each do |up|
      if days_difference < 7
        up.check_alert
      else
        up.update_alert(notifies?)
      end
    end
  end

  def add_alert(user)
    up = UserProject.create!(project_id: id, user_id: user.id)
    up.update_alert(self.notifies?)
  end

  def notifies?
    return false if end_date.blank?
    (end_date - DateTime.now.to_date < 7.days)
  end
  
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
end
