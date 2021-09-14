describe 'PUT api/v1/people', type: :request do
  # Needed to get auth_headers
  let!(:user) { create(:user) }
  let!(:person) { create(:person) }
  let!(:person_update) { build(:person) }
  let!(:params) do
    { person: person_update }
  end

  subject { put api_v1_person_path(person.id), params: params, headers: auth_headers, as: :json }

  it 'should return sucess' do
    subject
    expect(response).to have_http_status(:success)
  end

  it 'should respond proper person as JSON' do
    subject

    id = person[:id]
    full_name = "#{person_update[:first_name]} #{person_update[:last_name]}"

    person_update_reduced = person_update.slice(:first_name, :last_name, :hourly_load,
                                                :hourly_load_hours, :email)
    person_update_reduced.merge!(id: id, full_name: full_name)
    expect(json[:person]).to eq(person_update_reduced)
  end
end
