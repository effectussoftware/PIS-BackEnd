describe 'GET api/v1/people', type: :request do
  # Needed to get auth_headers
  let!(:user) { create(:user) }
  let!(:people) { create_list(:person, 10) }

  subject { get api_v1_people_path, headers: auth_headers, as: :json }

  it 'should return sucess' do
    subject
    expect(response).to have_http_status(:success)
  end

  it 'should return 10 people' do
    subject
    expect(json[:people].length).to eq(10)
  end
end
