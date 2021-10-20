class WebChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'web_channel'
    stream_for current_user
  end

  # Al conectarme verifico no tener notificaciones pendientes
  # puts "Por enviar mensaje desde connection"
  # current_user.check_alerts
  def unsubscribed
    stop_all_streams
  end

  def self.send_message(user, message)
    broadcast_to(
      user,
      data: message
    )
  end
end
