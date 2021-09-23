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

      it 'has invalid last_name' do
        person.last_name = ''
        expect(person).not_to be_valid
        expect(person.errors[:last_name]).to include("can't be blank")
      end

      it 'has invalid email' do
        person.email = ''
        expect(person).not_to be_valid
        expect(person.errors[:email]).to include("can't be blank")
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
        expect(person2.errors[:email]).to include('has already been taken')
      end
    end
  end
end
