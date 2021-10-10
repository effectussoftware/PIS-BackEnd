# require 'date'

describe 'POST api/v1/person_project', type: :request do
  # Needed to get auth_headers
  let!(:user) { create(:user) }
  let!(:person) { create(:person) }
  let!(:project) { create(:project) }
  let!(:person_project) { build(:person_project, person: person, project: project) }
  let!(:params) do
    { person_project: person_project }
  end

  subject do
    post api_v1_person_person_project_index_path(person.id), params: params,
                                                             headers: auth_headers, as: :json
  end

  it 'should return success' do
    subject
    expect(response).to have_http_status(:success)
  end

  it 'should change project count by one' do
    expect { subject }.to change { PersonProject.count }.by 1
  end
end
