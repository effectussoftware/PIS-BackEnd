describe 'PUT api/v1/projects', type: :request do
  # Needed to get auth_headers
  let!(:user) { create(:user) }
  let!(:project) { create(:project) }
  let!(:project_update) { build(:project) }
  let!(:params) do
    { project: project_update }
  end

  subject { put api_v1_project_path(project.id), params: params, headers: auth_headers, as: :json }

  it 'should return success' do
    subject
    expect(response).to have_http_status(:success)
  end

  it 'should respond proper person as JSON' do
    subject
    expect(json[:project][:id]).to eq(project[:id])
    expect(json[:project][:description]).to eq(project_update.description)
    expect(json[:project][:name]).to eq(project_update.name)
    expect(json[:project][:start_date]).to eq('2025-09-23')
    expect(json[:project][:project_type]).to eq(project_update.project_type)
    expect(json[:project][:project_state]).to eq(project_update.project_state)
  end

  context 'when updating technologies' do
    it 'correctly adds technologies' do
      former_technologies = %w[java ruby react psql]
      put api_v1_project_path(project.id),
          params: { project: { technologies: former_technologies } },
          headers: auth_headers, as: :json

      expect(@response).to have_http_status :success
      expect(json[:project][:technologies].size).to eq 4
      json[:project][:technologies].each do |tech|
        expect(tech.in?(former_technologies)).to be_truthy
      end

      put api_v1_project_path(project.id),
          params: { project: { technologies: ['rails'] } },
          headers: auth_headers, as: :json
      expect(@response).to have_http_status :success

      expect(json[:project][:technologies].size).to eq 5
      expect('rails'.in?(json[:project][:technologies])).to be_truthy
    end
  end
  context 'when patching technologies' do
    it 'will override older technologies' do
      former_technologies = %w[java ruby react psql]

      put api_v1_project_path(project.id),
          params: { project: { technologies: former_technologies } },
          headers: auth_headers, as: :json
      expect(@response).to have_http_status :success
      expect(json[:project][:technologies].size).to eq 4
      json[:project][:technologies].each do |tech|
        expect(tech.in?(former_technologies)).to be_truthy
      end

      latter_technologies = %w[ruby react psql]
      patch api_v1_project_path(project[:id]),
            params: { project: project_update.as_json.merge!(technologies: latter_technologies) },
            headers: auth_headers, as: :json
      expect(json[:project][:technologies].size).to eq 3
      json[:project][:technologies].each do |tech|
        expect(tech.in?(latter_technologies)).to be_truthy
      end
    end
  end
end
