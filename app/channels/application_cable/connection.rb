module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user, :broadcast_channel

    def connect
      client = request.params[:client]
      uid = request.params[:uid]
      token = request.params[:token]

      self.current_user = find_verified_user token, uid, client
    end

    private

    def find_verified_user(token, uid, client_id)
      user = User.find_by email: uid
      # http://www.rubydoc.info/gems/devise_token_auth/0.1.38/DeviseTokenAuth%2FConcerns%2FUser:valid_token%3F
      if user && user.valid_token?(token, client_id)
        user
      else
        reject_unauthorized_connection
      end
    end
  end
end
