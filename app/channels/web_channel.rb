class WebChannel < ApplicationCable::Channel

  def subscribed
    stream_from "web_channel"
    stream_for current_user
  end

  def unsubscribed
    stop_all_streams
  end

  def self.send_message(uid)

    self.broadcast_to(
      User.find_by(email: uid),
      data: 'A project is coming to an end'
    )
  end

end



