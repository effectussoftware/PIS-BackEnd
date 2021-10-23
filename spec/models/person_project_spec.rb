# == Schema Information
#
# Table name: person_projects
#
#  id                 :bigint           not null, primary key
#  person_id          :bigint           not null
#  project_id         :bigint           not null
#  role               :string
#  working_hours      :integer
#  working_hours_type :string
#  start_date         :date
#  end_date           :date
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_person_project                 (person_id,project_id,role,start_date,end_date) UNIQUE
#  index_person_projects_on_person_id   (person_id)
#  index_person_projects_on_project_id  (project_id)
#
require 'rails_helper'

RSpec.describe PersonProject, type: :model do
  describe 'validations' do
    let!(:person) { create(:person) }
    let!(:project) { create(:project) }
    let!(:person_project) { build(:person_project, person: person, project: project) }

    it 'test that factory is valid' do
      expect(person_project).to be_valid
    end

    context 'when fields are invalid' do
      it 'has invalid dates' do
        person_project.start_date = '2021-09-11'
        person_project.end_date = '2021-09-10'
        expect(person_project).not_to be_valid
      end

      it 'has invalid role' do
        person_project.role = ''
        expect(person_project).not_to be_valid
      end

      it 'has invalid start_date' do
        person_project.start_date = ''
        expect(person_project).not_to be_valid
      end

      it 'has invalid working_hours' do
        person_project.working_hours = ''
        expect(person_project).not_to be_valid
      end

      it 'has invalid working_hours_type' do
        person_project.working_hours = ''
        expect(person_project).not_to be_valid
      end

      it 'validate the uniqueness of role, project_id, person_id, start_date, end_date' do
        person_project1 = create(:person_project, person: person, project: project)
        expect(person_project1).to be_valid
        person_project2 = build(:person_project, person: person, project: project,
                                                 role: person_project1.role)
        expect(person_project2).not_to be_valid
        person_project2 = build(:person_project, person: person, project: project,
                                                 project_id: person_project1.project_id)
        expect(person_project2).not_to be_valid
        person_project2 = build(:person_project, person: person, project: project,
                                                 person_id: person_project1.person_id)
        expect(person_project2).not_to be_valid
        person_project2 = build(:person_project, person: person, project: project,
                                                 start_date: person_project1.start_date)
        expect(person_project2).not_to be_valid
        person_project2 = build(:person_project, person: person, project: project,
                                                 end_date: person_project1.end_date)
        expect(person_project2).not_to be_valid
      end
    end

    context 'when fields are valid' do
      it 'has valid dates' do
        person_project.start_date = '2021-09-10'
        person_project.end_date = '2021-09-11'
        expect(person_project).to be_valid
      end

      it 'set project end_date when is empty' do
        person_project1 = create(:person_project, person: person, project: project, end_date: '')
        expect(person_project1[:end_date]).to eq(project.end_date)
      end
    end

    it 'add role if is missing' do
      role = 'tester'
      create(:person_project, person: person, project: project, role: role)
      expect(Person.find(person.id).roles).to include role
    end
  end
end
