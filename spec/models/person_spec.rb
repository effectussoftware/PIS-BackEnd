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
  end
end
