describe 'PUT api/v1/projects', type: :request do
  # Needed to get auth_headers
  let!(:user) { create(:user) }
  let!(:project) { create(:project) }
  let!(:project_update) { build(:project) }
  let!(:params) do
    { project: project_update }
  end

  subject { put api_v1_project_path(project.id), params: params, headers: auth_headers, as: :json }

  it 'should return sucess' do
    subject
    expect(response).to have_http_status(:success)
  end

  it 'should respond proper person as JSON' do
    #falta implementar
  end
end
