describe 'GET api/v1/person_project', type: :request do
  # Needed to get auth_headers
  let!(:user) { create(:user) }
  let!(:person) { create(:person) }
  let!(:project) { create(:project) }
  let!(:person_project1) { create(:person_project, person: person, project: project) }
  let!(:person_project2) do
    create(:person_project, person: person, project: project, rol: 'tester')
  end

  subject do
    get api_v1_person_project_index_path, headers: auth_headers, as: :json
  end

  it 'should return success' do
    subject
    expect(response).to have_http_status(:success)
  end

  it 'person with two roles in the project' do
    subject
    full_name = "#{person.first_name} #{person.last_name}"
    expect(json[:person_project].length).to eq(1)
    person_body = json[:person_project].first[:person]
    expect(person_body[:id]).to eq(person.id)
    expect(person_body[:full_name]).to eq(full_name)
    expect(person_body[:projects].length).to eq(1)
    project_body = person_body[:projects].first
    expect(project_body[:id]).to eq(project.id)
    expect(project_body[:name]).to eq(project.name)
    dates = project_body[:dates]
    expect(dates.length).to eq(2)
    date0 = dates[0]
    expect(date0[:id]).to eq(person_project1.id)
    expect(date0[:rol]).to eq(person_project1.rol)
    expect(date0[:start_date]).to eq(person_project1.start_date.strftime('%F'))
    expect(date0[:end_date]).to eq(person_project1.end_date.strftime('%F'))
    date1 = dates[1]
    expect(date1[:id]).to eq(person_project2.id)
    expect(date1[:rol]).to eq(person_project2.rol)
    expect(date1[:start_date]).to eq(person_project2.start_date.strftime('%F'))
    expect(date1[:end_date]).to eq(person_project2.end_date.strftime('%F'))
  end
end
