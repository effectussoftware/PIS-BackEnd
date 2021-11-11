describe 'GET api/v1/person_project', type: :request do
  # Needed to get auth_headers
  let!(:user) { create(:user) }
  subject do
    get api_v1_person_project_index_path, headers: auth_headers, as: :json
  end
  context 'on basic tests' do
    let!(:person) { create(:person) }
    let!(:project) { create(:project) }

    let!(:person_project1) { create(:person_project, person: person, project: project) }
    let!(:person_project2) do
      create(:person_project, person: person, project: project, role: 'pm')
    end
    it 'should return success' do
      subject
      expect(response).to have_http_status(:success)
    end

    it 'person with two roles in the project' do
      subject
      full_name = "#{person.first_name} #{person.last_name}"
      expect(json[:person_project].length).to eq(1)
      person_body = json[:person_project].first[:person]
      expect(person_body[:id]).to eq(person.id)
      expect(person_body[:full_name]).to eq(full_name)
      expect(person_body[:projects].length).to eq(1)
      project_body = person_body[:projects].first
      expect(project_body[:id]).to eq(project.id)
      expect(project_body[:name]).to eq(project.name)
      dates = project_body[:dates]
      expect(dates.length).to eq(2)
      date0 = dates[0]
      expect(date0[:id]).to eq(person_project1.id)
      expect(date0[:role]).to eq(person_project1.role)
      expect(date0[:start_date]).to eq(person_project1.start_date.strftime('%F'))
      expect(date0[:end_date]).to eq(person_project1.end_date.strftime('%F'))
      date1 = dates[1]
      expect(date1[:id]).to eq(person_project2.id)
      expect(date1[:role]).to eq(person_project2.role)
      expect(date1[:start_date]).to eq(person_project2.start_date.strftime('%F'))
      expect(date1[:end_date]).to eq(person_project2.end_date.strftime('%F'))
    end
  end

  context 'on filter tests' do
    organization = 'ORG'
    p_state = 'amarillo'
    p_type = 'end_to_end'
    technologies = %w[java ruby]

    let(:used) do
      { project_state: p_state,
        project_type: p_type,
        organization: organization }
    end
    let(:unused) do
      { project_state: 'upcoming',
        project_type: 'tercerizado',
        organization: nil }
    end
    let(:partial_filter) { { project_state: p_state } }
    let(:full_filter) do
      { project_state: p_state,
        project_type: p_type,
        technologies: technologies,
        organization: organization }
    end
    let(:filter_technologies) { { technologies: technologies } }
    let(:filter_organization) { { organization: organization.downcase } }

    # Antes de cada test cargo 10 proyectos con parametros que no voy a usar en el filtrado
    let!(:load_unused_projects) do
      projects = create_list(:project, 10, unused)
      projects[0..2].each { |project| project.add_project_technologies technologies }
      projects
    end
    # En cada test creo la cantidad de tests correspondiente
    let!(:load_used_projects) do
      projects = create_list(:project, 5, used)
      projects.each { |project| project.add_project_technologies technologies }
      projects
    end
    let!(:assign_people_to_projects) do
      people = create_list(:person, 6)

      projects = load_used_projects
      # Cada persona de las 6 esta anotada a cada proyecto
      projects.each do |project|
        people.each do |person|
          create(:person_project, person: person, project: project, role: 'developer')
        end
      end
      # 0, 1, 2 estan en dos veces en el primer proyecto
      people[0..2].each do |person|
        create(:person_project, person: person, project: projects[0], role: 'pm')
      end
      # 0, 1, 2 estan tambien en los proyectos 0 1, 2 que solo entran en filtro tech
      projects = load_unused_projects
      projects[3..4].each do |project|
        people[0..2].each do |person|
          create(:person_project, person: person, project: project, role: 'pm')
        end
      end
      # Total 39 assocs; 33 tienen entran en los proyectos que se filtran
      # 3 personas libres
      create_list(:person, 3)
    end

    it 'works with empty filters' do
      get api_v1_person_project_index_path, headers: auth_headers, as: :json
      expect(response).to have_http_status(:success)
      expect(json[:person_project].length).to eq 6
      # Me gustaria cambiar esto por 9 pero no logre hacerlo
      expect(count_person_projects(json)).to eq 39
    end

    it 'works with partial filters' do
      get api_v1_person_project_index_path, params: partial_filter, headers: auth_headers, as: :json
      expect(response).to have_http_status(:success)

      expect(json[:person_project].length).to eq 6
      expect(count_person_projects(json)).to eq 33
    end

    it 'works with technologies filters' do
      get api_v1_person_project_index_path, params: filter_technologies, headers: auth_headers,
                                            as: :json
      expect(response).to have_http_status(:success)

      expect(json[:person_project].length).to eq 6
      expect(count_person_projects(json)).to eq 33
    end

    it 'works with full filters' do
      get api_v1_person_project_index_path, params: full_filter, headers: auth_headers, as: :json
      expect(response).to have_http_status(:success)

      expect(json[:person_project].length).to eq 6
      expect(count_person_projects(json)).to eq 33
    end

    it 'works with organization filter' do
      Project.first.update!(organization: 'ORGANIZATION COMPLETA')

      get api_v1_person_project_index_path, params: filter_organization, headers: auth_headers,
                                            as: :json

      expect(count_person_projects(json)).to eq 33
    end
  end
end

def count_person_projects(json)
  person_project_count = 0
  json[:person_project].each do |person|
    person[:person][:projects].each do |project|
      person_project_count += project[:dates].length
    end
  end
  person_project_count
end
