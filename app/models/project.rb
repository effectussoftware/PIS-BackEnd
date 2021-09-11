# == Schema Information
#
# Table name: projects
#
#  id          :bigint           not null, primary key
#  name        :string           not null
#  description :string
#  start_date  :date             not null
#  end_date    :date             not null
#  budget      :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Project < ApplicationRecord
  enum project_type: { staff_augmentation: 0, end_to_end: 1, tercerizado: 2 }
  enum project_state: { rojo: 0, amarillo: 1, verde: 2, upcomping: 3 }

  validates :name, :start_date, presence: true
  # validates :project_type, inclusion: {in: Project.project_types.values}
  # validates :project_state, inclusion: {in: Project.project_states.values}
  validate :end_date_is_after_start_date


  private

  def end_date_is_after_start_date
    return if end_date.blank? || start_date.blank?

    if end_date < start_date
      errors.add(:end_date, "cannot be before the start time")
    end
  end

end
