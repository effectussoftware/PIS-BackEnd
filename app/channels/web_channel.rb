
class WebChannel < ApplicationCable::Channel
  # Nota: Aca se pueden implementar metodos o "actions" los cuales
  #   un usuario conectado puede invocar a traves de la conexion, enviando
  #   un json { data: { action: "nombre_del_metodo",
  # parametros_opcionales: cualquier_cosa } }
  # Esto acompanado por un "def nombre_del_metodo(data) ...." y usando
  # data.fetch(:parametros_opcionales)
  # permite invocar metodos atraves del channel.
  #
  # Para el proposito de como definimos las alertas esto no es necesario pero puede llegar a ser
  # util si en algun momento se quisiera checkear las alertas de manera proactiva desde el frontend

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

end