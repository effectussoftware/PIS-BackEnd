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
    let(:project) { build(:project) }

    it 'test that factory is valid' do
      expect(project).to be_valid
    end

    context 'when fields are invalid' do
      it 'has invalid dates' do
        project.start_date = '2021-09-11'
        project.end_date = '2021-09-10'
        expect(project).not_to be_valid
      end

      it 'has invalid name' do
        project.name = ''
        expect(project).not_to be_valid
      end

      it 'has invalid start_date' do
        project.start_date = ''
        expect(project).not_to be_valid
      end

      it 'validate the uniqueness of name' do
        project1 = create(:project)
        expect(project1).to be_valid
        project2 = build(:project, name: project1.name)
        expect(project2).not_to be_valid
        expect(project2.errors[:name]).to include('has already been taken')
      end
    end


    context 'when fields are valid' do
      it 'has valid dates' do
        project.start_date = '2021-09-10'
        project.end_date = '2021-09-11'
        expect(project).to be_valid
      end
    end
  end
end