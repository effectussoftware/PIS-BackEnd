# == Schema Information
#
# Table name: people
#
#  id                :bigint           not null, primary key
#  first_name        :string           not null
#  last_name         :string           not null
#  email             :string
#  hourly_load       :string
#  hourly_load_hours :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_people_on_email  (email) UNIQUE
#
class Person < ApplicationRecord
  validates :first_name, :last_name, :hourly_load, :hourly_load_hours, presence: true
  validates :email, presence: true, uniqueness: true
  validates :hourly_load, inclusion: { in: %w[weekely daily] }
  validates :hourly_load_hours, inclusion: 20..45, if: :weekely?
  validates :hourly_load_hours, inclusion: 4..9, if: :daily?

  def weekely?
    hourly_load == 'weekely'
  end

  def daily?
    hourly_load == 'daily'
  end
end
