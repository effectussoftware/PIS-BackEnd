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
  has_many :person_technologies, dependent: :destroy
  has_many :technologies, through: :person_technologies

  validates :first_name, :last_name, :working_hours, presence: true
  validates :email, presence: true, uniqueness: true

  def add_person_technologies(technologies)
    return if technologies.blank? || !technologies.is_a?(Array)

    res = []
    technologies.each do |tech| # tech = [nombre_tecnologia, seniority]
      person_technology = add_technology(id, tech[0], tech[1])
      person_technologies << person_technology
      res.push person_technology
    end
    res
  end
end
