module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      request_params = request.params
      client = request_params[:client]
      uid = request_params[:uid]
      token = request_params[:token]

      user = User.find_by email: uid
      # http://www.rubydoc.info/gems/devise_token_auth/0.1.38/DeviseTokenAuth%2FConcerns%2FUser:valid_token%3F
      reject_unauthorized_connection unless user&.valid_token?(token, client)

      self.current_user = user
      # params[:current_user] = user

      # TODO: Pasar el mensaje que se envia al i18t
      WebChannel.send_message(user, 'test') if user.check_alerts?
    end
  end
end
