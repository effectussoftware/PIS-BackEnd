describe 'GET api/v1/projects', type: :request do
  # Needed to get auth_headers
  let!(:user) { create(:user) }
  let!(:projects) { create_list(:project, 10) }

  subject { get api_v1_projects_path, headers: auth_headers, as: :json }

  it 'should return success' do
    subject
    expect(response).to have_http_status(:success)
  end

  it 'should return 10 projects' do
    subject
    expect(json[:projects].length).to eq(10)
  end
end
