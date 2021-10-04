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

  def add_technology(person_id, technology_name, seniority)
    technology = Technology.find_or_create_single(technology_name)
    technology_id = technology.id
    person_technology = person_technologies.find_by(person_id: person_id,
                                                    technology_id: technology_id)
    if person_technology.blank?
      person_technology = person_technologies.create!(person_id: person_id,
                                                      technology_id: technology_id,
                                                      seniority: seniority)
    else
      person_technology.update!(seniority: seniority)
    end
    person_technology
  end
end
