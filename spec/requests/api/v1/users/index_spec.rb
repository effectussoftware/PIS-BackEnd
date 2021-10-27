describe 'GET api/v1/users', type: :request do
  # Needed to get auth_headers
  let!(:user) { create(:user) }
  let(:users) { create_list(:user, 10) }

  subject { get api_v1_users_path, headers: auth_headers, as: :json }

  it 'should return success' do
    subject
    expect(response).to have_http_status(:success)
    expect(json[:administrators].length).to eq(1)

    user_json = user.as_json
    user_json.delete 'allow_password_change'
    user_json.delete 'needs_password_reset'
    user_json['name'] = user.full_name

    expect(json[:administrators][0]).to eq(user_json)
  end

  it 'should return 11 users' do
    users
    subject

    expect(json[:administrators].length).to eq(11)
  end

  context 'when you dont add headers' do
    subject { get api_v1_users_path, as: :json }

    it 'does not authorize access' do
      subject
      expect(response).to have_http_status(:unauthorized)
    end

  end
end
