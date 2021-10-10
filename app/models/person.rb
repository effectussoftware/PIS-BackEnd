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
  has_many :person_project, dependent: :destroy
  has_many :projects, through: :person_project

  validates :first_name, :last_name, :working_hours, presence: true
  validates :email, presence: true, uniqueness: true

  def add_person_technologies(technologies)
    return if technologies.blank? || !technologies.is_a?(Array)

    res = PersonTechnology.add_person_technologies(id, technologies)
    res.each { |p_t| person_technologies << p_t }
    res
  end

  def rebuild_person_technologies(technologies)
    person_technologies.destroy_all
    add_person_technologies(technologies)
  end
end
