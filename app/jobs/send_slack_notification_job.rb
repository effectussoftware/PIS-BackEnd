class SendSlackNotificationJob < ApplicationJob
  def perform(message)
    HTTPX.post(ENV['SLACK_WEBHOOK_URL'].to_s, :json => {message: message})
  end
end