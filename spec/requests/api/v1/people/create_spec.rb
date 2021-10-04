describe 'POST api/v1/people', type: :request do
  # Needed to get auth_headers
  let!(:user) { create(:user) }
  let!(:person) { build(:person) }
  let!(:params) do
    { person: person }
  end

  subject { post api_v1_people_path, params: params, headers: auth_headers, as: :json }

  it 'should return success' do
    subject
    expect(response).to have_http_status(:success)
  end

  it 'should change person count by one' do
    expect { subject }.to change { Person.count }.by 1
  end

  it 'should respond proper person as JSON' do
    subject
    person_response = person.slice(:first_name, :last_name, :working_hours,
                                   :email, :technologies)
    person_response.merge!(id: Person.maximum(:id))
    full_name = "#{person_response[:first_name]} #{person_response[:last_name]}"
    person_response.merge!(full_name: full_name)
    expect(json[:person]).to eq(person_response)
  end
  context 'when adding technologies' do
    it 'correctly adds technologies' do
      post api_v1_people_path,
           params: params.merge!(technologies: [%w[Java senior],%w[ruby  junior], ["python 2.0", "senior"]]),
           headers: auth_headers, as: :json

      expect(@response).to have_http_status :success
      expect(json[:person][:technologies].size).eql? 3
    end

  end
end
