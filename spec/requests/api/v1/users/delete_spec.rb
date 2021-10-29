describe 'GET api/v1/users/', type: :request do
  # Needed to get auth_headers
  let!(:user) { create(:user) }

  subject do
    delete api_v1_users_path(User.id), headers: auth_headers, as: :json
  end

  it 'should return success' do
    subject
    expect(response).to have_http_status(:success)
  end

  it 'should delete the user on database' do
    expect { subject }.to change { User.count }.by(-1)
  end
end
