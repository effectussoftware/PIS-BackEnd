describe 'GET api/v1/projects', type: :request do
  # Needed to get auth_headers
  let!(:user) { create(:user) }
  let!(:project) { create(:project) }

  subject { delete api_v1_project_path(project.id), headers: auth_headers, as: :json } #no seria qpi_v1_projects_path...?

  it 'should return sucess' do
    subject
    expect(response).to have_http_status(:success)
  end

  it 'shoud delete the project on database' do
    expect { subject }.to change { Project.count }.by(-1)
  end
end
