describe 'GET api/v1/projects/:id', type: :request do
  # Needed to get auth_headers
  let!(:user) { create(:user) }
  let!(:project) { create(:project) }

  subject { get api_v1_project_path(project.id), headers: auth_headers, as: :json }

  it 'should return success' do
    subject
    expect(response).to have_http_status(:success)
  end

  it 'should respond proper project as JSON' do
    subject
    expect(json[:project][:id]).to eq(project.id)
    expect(json[:project][:description]).to eq(project.description)
    expect(json[:project][:name]).to eq(project.name)
    expect(json[:project][:start_date]).to eq('2025-09-23')
    expect(json[:project][:project_type]).to eq(project.project_type)
    expect(json[:project][:project_state]).to eq(project.project_state)
  end
end
