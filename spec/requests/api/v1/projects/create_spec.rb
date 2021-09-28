describe 'POST api/v1/projects', type: :request do
  # Needed to get auth_headers
  let!(:user) { create(:user) }
  let!(:project) { build(:project) }
  let!(:params) do
    { project: project }
  end

  subject { post api_v1_projects_path, params: params, headers: auth_headers, as: :json }

  it 'should return sucess' do
    subject
    expect(response).to have_http_status(:success)
  end

  it 'should change project count by one' do
    expect { subject }.to change { Project.count }.by 1
  end

  it 'should respond proper project as JSON' do
    #esta mal, hay que implementarlo bien
    subject
    project_response = project.slice(:name, :description, :start_date,
                                     :project_type, :project_state)
    project_response.merge!(id: Project.maximum(:id))
    full_name = "#{person_response[:first_name]} #{person_response[:last_name]}"
    person_response.merge!(full_name: full_name)

    expect(json[:person]).to eq(person_response)
  end
end
