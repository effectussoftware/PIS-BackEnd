# == Schema Information
#
# Table name: people
#
#  id                :bigint           not null, primary key
#  first_name        :string           not null
#  last_name         :string           not null
#  email             :string
#  hourly_load       :integer
#  hourly_load_hours :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_people_on_email  (email) UNIQUE
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
        expect(person.errors[:first_name]).to include("can't be blank")
      end

      it 'has invalid first_name' do
        person.last_name = ''
        expect(person).not_to be_valid
        expect(person.errors[:last_name]).to include("can't be blank")
      end

      it 'has invalid first_name' do
        person.email = ''
        expect(person).not_to be_valid
        expect(person.errors[:email]).to include("can't be blank")
      end

      it 'has invalid weekely' do
        person1 = build(:person,
                        hourly_load: Person.hourly_load_types[:weekely],
                        hourly_load_hours: 19)
        expect(person1).not_to be_valid
        person1.hourly_load_hours = 46
        expect(person1).not_to be_valid
      end

      it 'has invalid daily' do
        person1 = build(:person,
                        hourly_load: Person.hourly_load_types[:daily],
                        hourly_load_hours: 3)
        expect(person1).not_to be_valid
        person1.hourly_load_hours = 10
        expect(person1).not_to be_valid
      end
    end

    context 'when fields are valid' do
      it 'has valid weekely' do
        person1 = build(:person,
                        hourly_load: Person.hourly_load_types[:weekely],
                        hourly_load_hours: 20)
        expect(person1).to be_valid
        person1.hourly_load_hours = 45
        expect(person1).to be_valid
      end

      it 'has valid daily' do
        person1 = build(:person,
                        hourly_load: Person.hourly_load_types[:daily],
                        hourly_load_hours: 4)
        expect(person1).to be_valid
        person1.hourly_load_hours = 9
        expect(person1).to be_valid
      end
    end
  end
end
