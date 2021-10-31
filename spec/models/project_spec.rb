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

    context 'when filtering projects' do
      organization = 'org'
      p_state = 'amarillo'
      p_type = 'end_to_end'
      technologies = %w[java ruby]

      # Les agrego as json para que ponga las keys como strings y
      # no como symbols. Desde el front van a venir por string por
      # default.
      let(:partial_filter) { { project_state: p_state }.as_json }
      let(:full_filter) do
        { project_state: p_state,
          project_type: p_type,
          technologies: technologies,
          organization: organization }.as_json
      end
      let(:filter_technologies) { { technologies: technologies }.as_json }

      context 'when tables are empty' do
        it 'works with full filter' do
          expect(Project.filter(full_filter)).to eq []
        end

        it 'works with a partial filter' do
          expect(Project.filter(partial_filter)).to eq []
        end

        it 'works with a technologies filter' do
          expect(Project.filter(filter_technologies)).to eq []
        end
      end

      context 'when tables have projects' do
        let!(:load_projects) do
          # Los params que pongo aca tienen que ser los que no se usan
          params = { project_state: 'verde', project_type: 'tercerizado', organization: 'no_usada' }
          create_list(:project, 5, params)
        end

        it 'returns all when filters are empty' do
          expect(Project.filter({}).length).to eq 5
        end

        it 'works with a technologies filter' do
          project = Project.first
          project.add_project_technologies(technologies)
          filtered = Project.filter(filter_technologies)
          expect(filtered.length).to eq 1
          expect(filtered.first).to eq project
        end

        it 'works with a partial filter' do
          project = Project.first
          project.update!(project_state: p_state)
          filtered = Project.filter(partial_filter)
          expect(filtered.length).to eq 1
          expect(filtered.first).to eq project
        end

        it 'works with full filters' do
          project = Project.first
          project.update!(project_state: p_state,
                          project_type: p_type,
                          organization: organization)
          project.add_project_technologies(technologies)
          filtered = Project.filter(full_filter)

          expect(filtered.length).to eq 1
          expect(filtered.first).to eq project
        end

        it 'wont alter the current table' do
          Project.first.update!(project_state: p_state)

          init = Project.all.order(:id)
          expect(init.length).to eq 5

          filtered = Project.filter(partial_filter).order(:id)

          filtered.each { |one| expect(init.include?(one)).to be_truthy }
          expect(Project.all.order(:id)).to eq init
        end
      end

      context 'when some projects dont have technologies' do
        let!(:load_projects) do
          params = { project_state: 'verde', project_type: 'tercerizado', organization: 'no_usada' }
          create_list(:project, 4, params)
        end
        it 'returns right amount of projects' do
          Project.first(2).each do |project|
            project.add_project_technologies(technologies)
          end

          expect(Project.filter(filter_technologies).length).to eq 2
        end
      end
    end
  end
end
