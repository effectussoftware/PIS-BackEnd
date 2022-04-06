class SendSlackNotificationJob < ApplicationJob
  def perform(message)
    Notifications::Send.new(message).send
  end
end