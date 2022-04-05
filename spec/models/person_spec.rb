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
#  roles         :text             default([]), is an Array
#  is_leader     :boolean          default(FALSE)
#  leader_id     :bigint
#
# Indexes
#
#  index_people_on_email      (email) UNIQUE
#  index_people_on_leader_id  (leader_id)
#
require 'rails_helper'

RSpec.describe Person, type: :model do
  describe 'validations' do
    let(:person) { build(:person) }

    it 'test that factory is valid' do
      expect(person).to be_valid
    end

    context 'when fields are invalid' do
      it 'has invalid first_name' do
        person.first_name = ''
        expect(person).not_to be_valid
      end

      it 'has invalid last_name' do
        person.last_name = ''
        expect(person).not_to be_valid
      end

      it 'has invalid email' do
        person.email = ''
        expect(person).not_to be_valid
      end

      it 'has invalid working hours' do
        person.working_hours = ''
        expect(person).not_to be_valid
      end

      it 'validate the uniqueness of email' do
        person1 = create(:person)
        expect(person1).to be_valid
        person2 = build(:person, email: person1.email)
        expect(person2).not_to be_valid
      end
    end

    context 'when adding technologies' do
      it 'adds new technologies' do
        person1 = create(:person)
        person_technologies = person1.add_person_technologies([%w[Java senior]])

        expect(person_technologies).not_to be_falsey
        person_technologies.each { |person_technology| expect(person_technology).to be_valid }
      end

      it 'updates old technologies' do
        person = create(:person)
        person_technologies = person.add_person_technologies([%w[Java senior]])

        expect(person_technologies).not_to be_falsey
        expect(person_technologies[0]).to be_valid

        person.add_person_technologies([%w[Java junior]])
        java = Technology.find_by name: 'java'
        expect(person.person_technologies.find_by(
          technology_id: java.id
        ).seniority == 'junior').to be_truthy
      end

      it 'has many technologies' do
        person = create(:person)

        person.add_person_technologies([%w[Java senior], %w[Ruby senior]])

        expect(person.technologies.size == 2).to be_truthy
      end

      it 'it destroys its technologies' do
        person = create(:person)

        person.add_person_technologies([%w[Java senior], %w[Ruby senior]])
        expect(person.technologies.size == 2).to be_truthy

        person_id = person.id

        person.destroy!

        expect(PersonTechnology.find_by(person_id: person_id)).to be_nil
      end
    end
  end
end
