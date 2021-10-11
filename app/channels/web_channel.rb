
class WebChannel < ApplicationCable::Channel

  def subscribed
    stream_from "web_channel"
    stream_for current_user
  end

  def unsubscribed
    stop_all_streams
  end

  def self.send_message(user_stream)
    self.broadcast_to(
      user_stream,
      data: 'You have pending notifications'
    )
  end
end