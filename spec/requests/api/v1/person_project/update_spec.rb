describe 'PUT api/v1/person_project', type: :request do
  # Needed to get auth_headers
  let!(:user) { create(:user) }
  let!(:person) { create(:person) }
  let!(:project) { create(:project) }
  let!(:person_project) { create(:person_project, person: person, project: project) }
  let!(:person_project_update) do
    build(:person_project, person: person, project: project, rol: 'tester')
  end
  let!(:params) do
    { person_project: person_project_update }
  end

  subject do
    put api_v1_person_project_path(person_project.id), params: params, headers: auth_headers,
                                                       as: :json
  end

  it 'should return success' do
    subject
    expect(response).to have_http_status(:success)
  end

  it 'should respond proper person as JSON' do
    # remove created_at, updated_at
    person_reduced = person.slice(:id, :first_name, :last_name, :email, :working_hours)
    # remove created_at, updated_at
    project_reduced = project.slice(:id, :name, :description, :start_date, :end_date, :budget,
                                    :project_state, :project_type)
    # format dates
    project_reduced[:start_date] = project[:start_date].strftime('%F')
    project_reduced[:end_date] = project[:end_date].strftime('%F')

    # add full_name
    full_name = "#{person.first_name} #{person.last_name}"
    person_reduced[:full_name] = full_name

    # add person and project
    response_body = person_project_update.attributes.merge(person: person_reduced,
                                                           project: project_reduced)
    # remove created_at, updated_at
    response_reduced = response_body.symbolize_keys.slice(:id, :rol, :working_hours, :working_hours_type, :start_date, :end_date,
                                                          :person, :project)
    # set id
    response_reduced[:id] = person_project.id
    # format dates
    response_reduced[:start_date] = person_project[:start_date].strftime('%F')
    response_reduced[:end_date] = person_project[:end_date].strftime('%F')
    subject
    expect(json[:person_project]).to eq(response_reduced.stringify_keys)
  end
end
