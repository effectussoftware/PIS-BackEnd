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

  validates :person_id, uniqueness: { scope: [:technology_id] }
end
