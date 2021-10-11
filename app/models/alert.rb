class Alert < ApplicationRecord
  self.abstract_class = true
  belongs_to :user

  with_options presence: true, allow_blank: false do
    validates :notification_active
    validates :not_seen
  end

  def notifies?
    notification_active && not_seen
  end

  # Metodo que se llama cuando se actualiza el objeto que alerta
  def update_alert(notifies)
    if notification_active != notifies
      self.update(notification_active: notifies, not_seen: true)
    end
    check_alert
  end

  def check_alert
    return unless notifies
    WebChannel.send_message(user)
  end

  def get_notification
    puts "Soy un metodo en alert"
    puts project_id
    puts project_id
  end

end
