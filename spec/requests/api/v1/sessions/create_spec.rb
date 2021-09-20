describe 'POST api/v1/users/sign_in', type: :request do
  let(:password) { 'password' }
  let(:token) do
    {
      '70crCAAYmNP1xLkKKM09zA' =>
      {
        'token' => '$2a$10$mSeRnpVMaaegCpn3AhORGe5wajFhgMoBjGIrMwq4Qq2mP6f/OHu1y',
        'expiry' => 153_574_356_4
      }
    }
  end
  let(:user) { create(:user, password: password, tokens: token) }
  let(:params) do
    {
      user:
        {
          email: user.email,
          password: password
        }
    }
  end

  subject { post new_user_session_path, params: params, as: :json }

  context 'with correct params' do
    it 'returns 401, user needs change password' do
      subject
      expect(response).not_to be_successful
    end

    it 'returns 401, user needs change password' do
      subject
      expect(json[:needs_password_reset]).to be(true)
    end

    it 'user changed they password, returns the user' do
      user.needs_password_reset = false
      user.save!
      subject
      expect(json[:user][:id]).to eq(user.id)
      expect(json[:user][:email]).to eq(user.email)
      expect(json[:user][:uid]).to eq(user.uid)
      expect(json[:user][:provider]).to eq('email')
      expect(json[:user][:first_name]).to eq(user.first_name)
      expect(json[:user][:last_name]).to eq(user.last_name)
    end

    it 'returns a valid client and access token' do
      subject
      token = response.header['access-token']
      client = response.header['client']
      expect(user.reload.valid_token?(token, client)).to be_truthy
    end
  end

  context 'with incorrect params' do
    it 'return errors upon failure' do
      params = {
        user: {
          email: user.email,
          password: 'wrong_password!'
        }
      }
      post new_user_session_path, params: params, as: :json

      expect(response).to be_unauthorized
      expected_response = {
        error: 'Invalid login credentials. Please try again.'
      }.with_indifferent_access
      expect(json).to eq(expected_response)
    end
  end
end
