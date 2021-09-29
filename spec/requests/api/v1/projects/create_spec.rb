# require 'date'

describe 'POST api/v1/projects', type: :request do
  # Needed to get auth_headers
  let!(:user) { create(:user) }
  let!(:project) { build(:project) }
  let!(:params) do
    { project: project }
  end

  subject { post api_v1_projects_path, params: params, headers: auth_headers, as: :json }

  it 'should return success' do
    subject
    expect(response).to have_http_status(:success)
  end

  it 'should change project count by one' do
    expect { subject }.to change { Project.count }.by 1
  end

  it 'should respond proper project as JSON' do
    subject
    expect(json[:project][:id]).to eq(Project.maximum(:id))
    expect(json[:project][:description]).to eq(project.description)
    expect(json[:project][:name]).to eq(project.name)
    expect(json[:project][:start_date]).to eq('2025-09-23')
    expect(json[:project][:project_type]).to eq(project.project_type)
    expect(json[:project][:project_state]).to eq(project.project_state)
  end
end
