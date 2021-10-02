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
  has_many :person_technology, dependent: :destroy
  has_many :technologies, through: :person_technology

  validates :first_name, :last_name, :working_hours, presence: true
  validates :email, presence: true, uniqueness: true

  def add_technology(technology, seniority)
    person_technology = PersonTechnology.find_by(person_id: id, technology_id: technology.id)
    if person_technology.blank?
      person_technology = PersonTechnology.create(person_id: id, technology_id: technology.id, seniority: seniority)
    else
      person_technology.update(seniority: seniority)
      # person_technology.seniority = seniority
      # person_technology.save
      # PersonTechnology.update(id: person_technology.id, seniority: seniority)
    end
    person_technology
  end
end
