module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      client = request.params[:client]
      uid = request.params[:uid]
      token = request.params[:token]

      user = find_verified_user token, uid, client
      self.current_user = user

      # Al conectarme verifico no tener notificaciones pendientes
      user.check_alerts
    end

    private

    def find_verified_user(token, uid, client_id)
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
