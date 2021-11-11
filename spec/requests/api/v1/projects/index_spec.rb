describe 'GET api/v1/projects', type: :request do
  # Needed to get auth_headers
  let!(:user) { create(:user) }
  subject { get api_v1_projects_path, headers: auth_headers, as: :json }

  context 'on basic tests' do
    let!(:projects) { create_list(:project, 10) }

    it 'should return success' do
      subject
      expect(response).to have_http_status(:success)
    end

    it 'should return 10 projects' do
      subject
      expect(json[:projects].length).to eq(10)
    end
  end

  context 'when applying filters' do
    organization = 'org'
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

    # Antes de cada test cargo 10 proyectos con parametros que no voy a usar en el filtrado
    let!(:load_unused_projects) { create_list(:project, 10, unused) }
    # En cada test creo la cantidad de tests correspondiente
    let(:load_used_projects) { create_list(:project, 5, used) }

    it 'works with empty filter' do
      load_used_projects

      get api_v1_projects_path, headers: auth_headers, as: :json
      expect(response).to have_http_status(:success)
      expect(json[:projects].length).to eq 15
    end

    it 'works with a partial filter' do
      load_used_projects
      create(:project, project_state: p_state)

      get api_v1_projects_path, params: partial_filter, headers: auth_headers, as: :json
      expect(response).to have_http_status(:success)
      expect(json[:projects].length).to eq 6
    end

    it 'works with full filter' do
      projects = load_used_projects
      projects.each do |project|
        put api_v1_project_path(project.id), params: { project: { technologies: technologies } },
                                             headers: auth_headers, as: :json
      end

      get api_v1_projects_path, params: full_filter, headers: auth_headers, as: :json
      expect(response).to have_http_status(:success)
      expect(json[:projects].length).to eq 5
    end

    it 'works with a technologies filter' do
      get api_v1_projects_path, params: filter_technologies, headers: auth_headers, as: :json
      expect(response).to have_http_status(:success)
      expect(json[:projects].length).to eq 0

      projects = load_used_projects
      projects.each_with_index do |project, index|
        if index < 3
          put api_v1_project_path(project.id), params: { project: { technologies: ['java'] } },
                                               headers: auth_headers, as: :json
        end
        unless index < 3
          put api_v1_project_path(project.id), params: { project: { technologies: technologies } },
                                               headers: auth_headers, as: :json
        end
      end

      get api_v1_projects_path, params: filter_technologies, headers: auth_headers, as: :json
      expect(json[:projects].length).to eq 5
    end

    # por correctly me refiero a buscar 'fin' devuelve todas dentro de
    # {'FING', 'fin', 'Finlandia', 'fInG' etc } -> fin%
    it 'filters organizations correctly' do
      create(:project, organization: 'FING')
      create(:project, organization: 'fin')
      create(:project, organization: 'Finlandia')
      create(:project, organization: 'fInG')
      # estas no
      create(:project, organization: 'not fing')
      create(:project, organization: nil)

      get api_v1_projects_path, params: { organization: 'fin' }, headers: auth_headers, as: :json
      expect(json[:projects].length).to eq 4
    end

    it 'resets filters after response' do
      load_used_projects

      get api_v1_projects_path, params: partial_filter, headers: auth_headers, as: :json
      expect(json[:projects].length).to eq 5

      get api_v1_projects_path, headers: auth_headers, as: :json
      expect(json[:projects].length).to eq 15
    end
  end
end
