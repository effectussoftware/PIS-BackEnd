describe 'GET api/v1/person_project/:id', type: :request do
  # Needed to get auth_headers
  let!(:user) { create(:user) }
  let!(:person) { create(:person) }
  let!(:project) { create(:project) }
  let!(:person_project) { create(:person_project, person: person, project: project) }

  subject { get api_v1_person_project_path(person_project.id), headers: auth_headers, as: :json }

  it 'should return success' do
    subject
    expect(response).to have_http_status(:success)
  end

  it 'should respond proper project as JSON' do
    subject
    expect(json[:person_project][:id]).to eq(PersonProject.maximum(:id))
    expect(json[:person_project][:rol]).to eq(person_project.rol)
    expect(json[:person_project][:working_hours]).to eq(person_project.working_hours)
    expect(json[:person_project][:working_hours_type]).to eq(person_project.working_hours_type)
    expect(json[:person_project][:start_date]).to eq(person_project.start_date.strftime('%F'))
    expect(json[:person_project][:end_date]).to eq(person_project.end_date.strftime('%F'))
    expect(json[:person_project][:person][:id]).to eq(person.id)
    expect(json[:person_project][:person][:first_name]).to eq(person.first_name)
    expect(json[:person_project][:person][:last_name]).to eq(person.last_name)
    expect(json[:person_project][:person][:email]).to eq(person.email)
    expect(json[:person_project][:person][:working_hours]).to eq(person.working_hours)
    full_name = "#{person.first_name} #{person.last_name}"
    expect(json[:person_project][:person][:full_name]).to eq(full_name)
    expect(json[:person_project][:project][:id]).to eq(project.id)
    expect(json[:person_project][:project][:name]).to eq(project.name)
    expect(json[:person_project][:project][:description]).to eq(project.description)
    expect(json[:person_project][:project][:start_date]).to eq(project.start_date.strftime('%F'))
    expect(json[:person_project][:project][:end_date]).to eq(project.end_date.strftime('%F'))
    expect(json[:person_project][:project][:project_state]).to eq(project.project_state)
    expect(json[:person_project][:project][:project_type]).to eq(project.project_type)
    expect(json[:person_project][:project][:budget]).to eq(project.budget)
  end
end
