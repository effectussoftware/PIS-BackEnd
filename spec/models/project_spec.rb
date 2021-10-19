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
#  organization  :string
#
# Indexes
#
#  index_projects_on_name  (name) UNIQUE
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
      end
    end

    context 'when fields are valid' do
      it 'has valid dates' do
        project.start_date = '2021-09-10'
        project.end_date = '2021-09-11'
        expect(project).to be_valid
      end
    end

    context 'when adding technologies' do
      it 'correctly adds technologies' do
        project = create(:project)
        project_technologies = project.add_project_technologies(%w[ruby rails psql])

        expect(project_technologies).not_to be_falsey
        expect(project.project_technologies.size).to eq 3
      end

      it 'adds new technologies' do
        project = create(:project)
        project.add_project_technologies(%w[ruby rails])

        project_technologies = project.project_technologies
        expect(project_technologies).not_to be_falsey
        expect(project_technologies.size).to eq 2
        project_technologies.each { |project_technology| expect(project_technology).to be_valid }

        project.add_project_technologies(%w[psql])
        project_technologies = project.project_technologies
        expect(project_technologies.size).to eq 3

        expect('psql'.in?(project.technologies.collect(&:name))).to be_truthy
      end

      it 'wont have repeated technologies' do
        project = create(:project)
        project.add_project_technologies(%w[java ruby])

        project_technologies = project.project_technologies
        expect(project_technologies).not_to be_falsey
        expect(project_technologies[0]).to be_valid
        expect(project_technologies.size).to eq 2

        project.add_project_technologies(%w[java])
        project_technologies = project.project_technologies
        expect(project_technologies.size).to eq 2
      end

      it 'has many technologies' do
        project = create(:project)

        project.add_project_technologies(%w[java ruby])

        expect(project.technologies.size == 2).to be_truthy
      end

      it 'destroys its technologies' do
        project = create(:project)

        project.add_project_technologies(%w[java ruby])

        expect(project.technologies.size == 2).to be_truthy

        project_id = project.id

        project.destroy!

        expect(ProjectTechnology.find_by(project_id: project_id)).to be_nil
      end
    end
  end
end
