describe 'GET api/v1/projects/:id', type: :request do
  # Needed to get auth_headers
  let!(:user) { create(:user) }
  let!(:project) { create(:project) }

  subject { get api_v1_project_path(project.id), headers: auth_headers, as: :json }

  it 'should return sucess' do
    subject
    expect(response).to have_http_status(:success)
  end

  it 'should respond proper project as JSON' do
    #falta implementar
  end
end
