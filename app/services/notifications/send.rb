class Notifications::Send
 attr_reader :message

 def initialize(message)
   @message = message
 end

 def send
  byebug
  HTTPX.post(ENV['SLACK_WEBHOOK_URL'].to_s, json: {message: message})
 end
end