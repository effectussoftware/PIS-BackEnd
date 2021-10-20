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
    update!(notification_active: notifies, not_seen: true) if notification_active != notifies
    check_alert
  end

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

  def get_alert(id, alert_type)
    case alert_type
    when 'project'
      up = UserProject.find(id)
      up.obtain_notifications
    when 'person'
      # type code here
    end
  end
end
