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
    #byebug
    if notification_active != notifies
      self.update(notification_active: notifies, not_seen: true)
    end
    check_alert
  end

  def check_alert
    return unless notifies?
    WebChannel.send_message(user, "Alerta:  id=#{id}")
  end

  def see_notification
    self.update(not_seen: false)
  end


end
