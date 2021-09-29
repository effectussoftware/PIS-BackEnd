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
end
