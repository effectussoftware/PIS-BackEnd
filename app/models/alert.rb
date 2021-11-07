class Alert < ApplicationRecord
  self.abstract_class = true
  belongs_to :user

  # Puede tener valores nil de
  # :notification_active, :not_seen
  # porque tiene valor

  def notifies?
    notification_active && not_seen
  end

  # Metodo que se llama cuando se actualiza el objeto que alerta
  def update_alert(notifies, not_seen)
    # FIXME: Si los valores quedarian iguales no hacer update
    # if (notification_active != notifies || !not_seen)
    update!(notification_active: notifies, not_seen: not_seen)
    check_alert
  end

  def check_alert
    return unless notifies?

    WebChannel.send_message(user, "Alerta:  id=#{id}")
  end

  def see_notification
    update(not_seen: false)
  end

  def obtain_notification
    raise NoMethodError 'Unimplemented method' # TODO: Mover mensaje a locale
  end

  def add_notification(res)
    res.push(obtain_notification) if notifies?
  end
end
