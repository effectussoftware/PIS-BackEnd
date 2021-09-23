describe 'GET api/v1/people/:id', type: :request do
  # Needed to get auth_headers
  let!(:user) { create(:user) }
  let!(:person) { create(:person) }

  subject { get api_v1_person_path(person.id), headers: auth_headers, as: :json }

  it 'should return sucess' do
    subject
    expect(response).to have_http_status(:success)
  end

  it 'should respond proper person as JSON' do
    subject
    created_person = person.slice(:id, :first_name, :last_name, :email,
                                  :working_hours)
    full_name = "#{created_person[:first_name]} #{created_person[:last_name]}"
    created_person.merge!(full_name: full_name)
    expect(json[:person]).to eq(created_person)
  end
end
