# == Schema Information
#
# Table name: person_technologies
#
#  id            :bigint           not null, primary key
#  person_id     :bigint           not null
#  technology_id :bigint           not null
#  seniority     :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_person_technologies_on_person_id                    (person_id)
#  index_person_technologies_on_person_id_and_technology_id  (person_id,technology_id) UNIQUE
#  index_person_technologies_on_technology_id                (technology_id)
#
class PersonTechnology < ApplicationRecord
  belongs_to :person
  belongs_to :technology

  SONORITIES = %w[junior senior semi-senior].freeze

  validates :person_id, uniqueness: { scope: [:technology_id] }
  validates :seniority, inclusion: { in: PersonTechnology::SONORITIES }

  def self.add_technology(person_id, technology_name, seniority)
    technology = Technology.find_or_create_single(technology_name)
    technology_id = technology.id
    person_technology = find_by(person_id: person_id,
                                technology_id: technology_id)
    if person_technology.blank?
      person_technology = create!(person_id: person_id,
                                  technology_id: technology_id,
                                  seniority: seniority)
      return person_technology
    else
      person_technology.update!(seniority: seniority)
    end
    nil
  end

  def self.add_person_technologies(id_person, technologies)
    res = []
    technologies.each do |tech| # tech = [nombre_tecnologia, seniority]
      new_tech = PersonTechnology.add_technology(id_person, tech[0], tech[1])
      res.push new_tech unless new_tech.nil?
    end
    res
  end
end
