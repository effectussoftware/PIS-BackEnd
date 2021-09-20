require_relative '../support/acceptance_tests_helper'

resource 'Sessions' do
  header 'Content-Type', 'application/json'
  header 'access-token', :access_token_header
  header 'client', :client_header
  header 'uid', :uid_header

  let(:user) { create(:user) }

  route 'api/v1/users/sign_in', 'Session' do
    let(:request) do
      {
        user:
          {
            email: user.email,
            password: user.password
          },
        format: :json
      }
    end

    post 'Create' do
      example 'Bad, can log in before password changed' do
        do_request(request)

        expect(status).to eq 401
      end

      example 'Bad' do
        user.needs_password_reset = false
        user.save!
        request[:user][:password] = 'wrong-password'
        do_request(request)
        expect(status).to eq 401
      end

      example 'Ok' do
        user.needs_password_reset = false

        do_request(request)
        expect(status).to eq 200
      end
    end
  end

  route 'api/v1/users/sign_out', 'Session' do
    let(:user) { create(:user) }

    delete 'Delete' do
      example 'Ok' do
        do_request

        expect(status).to eq 200
      end

      example 'Bad' do
        auth_headers['access-token'] = 'notvalidtoken'
        do_request

        expect(status).to eq 404
      end
    end
  end
end
