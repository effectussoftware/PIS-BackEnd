# == Schema Information
#
# Table name: projects
#
#  id            :bigint           not null, primary key
#  name          :string           not null
#  description   :string           not null
#  start_date    :date             not null
#  end_date      :date
#  budget        :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  project_state :string           not null
#  project_type  :string           not null
#
require 'rails_helper'

RSpec.describe Project, type: :model do
  describe 'validations' do
    let(:project1) { build(:project) }

    it 'test that factory is valid' do
      expect(project1).to be_valid
    end

    context 'when fields are invalid' do
      it 'has invalid dates' do
        project1.start_date = '2021-09-11'
        project1.end_date = '2021-09-10'
        expect(project1).not_to be_valid
      end
    end

    context 'when fields are valid' do
      it 'has valid dates' do
        project1.start_date = '2021-09-10'
        project1.end_date = '2021-09-11'
        expect(project1).to be_valid
      end

      it 'already exists' do
        project1.name = 'Proyecto 1'
        expect(project1).to be_valid
        project1.save

        project2 = build(:project)
        project2.name = 'Proyecto 1'
        expect(project2).not_to be_valid

      end
    end
  end
end
