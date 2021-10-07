class WebChannel < ApplicationCable::Channel
  def subscribed
    stream_from "web_channel"
  end

  def unsubscribed
    stop_all_streams
  end
end
