describe 'DELETE api/v1/person_project', type: :request do
  # Needed to get auth_headers
  let!(:user) { create(:user) }
  let!(:person) { create(:person) }
  let!(:project) { create(:project) }
  let!(:person_project) { create(:person_project, person: person, project: project) }

  subject do
    delete api_v1_person_project_path(person_project.id), headers: auth_headers, as: :json
  end

  it 'should return success' do
    subject
    expect(response).to have_http_status(:success)
  end

  it 'should delete the project on database' do
    expect { subject }.to change { PersonProject.count }.by(-1)
  end
end
