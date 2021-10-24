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
  def update_alert(notifies)
    # FIXME: Si los valores quedarian iguales no hacer update
    # if (notification_active != notifies || !not_seen)
    update!(notification_active: notifies, not_seen: true)
    check_alert
  end

  # TODO: Borrar si funciona update proyect con update alert
  def reset_alert(notifies)
    update!(notification_active: notifies, not_seen: true)
    check_alert
  end

  def check_alert
    return unless notifies?

    WebChannel.send_message(user, "Alerta:  id=#{id}")
  end

  def see_notification
    update(not_seen: false)
  end

  # Get alert
  def self.alert(id, alert_type)
    case alert_type
    when 'project'
      UserProject.find(id)
      # up = UserProject.find(id)
      # up.obtain_notifications TODO ver si mover
    when 'person'
      # type code here
    end
  end

  def obtain_notification
    raise NoMethodError 'Unimplemented method' # TODO: Mover mensaje a locale
  end
end