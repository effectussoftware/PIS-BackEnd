# == Schema Information
#
# Table name: people
#
#  id            :bigint           not null, primary key
#  first_name    :string           not null
#  last_name     :string           not null
#  email         :string
#  working_hours :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_people_on_email  (email) UNIQUE
#
class Person < ApplicationRecord
  # has_many :user_person
  has_many :people, through: :user_people
  validates :first_name, :last_name, :working_hours, presence: true
  validates :email, presence: true, uniqueness: true
end
