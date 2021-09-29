describe 'GET api/v1/people', type: :request do
  # Needed to get auth_headers
  let!(:user) { create(:user) }
  let!(:person) { create(:person) }

  subject { delete api_v1_person_path(person.id), headers: auth_headers, as: :json }

  it 'should return success' do
    subject
    expect(response).to have_http_status(:success)
  end

  it 'should delete the person on database' do
    expect { subject }.to change { Person.count }.by(-1)
  end
end
