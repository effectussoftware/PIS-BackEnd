class AlertJob < ApplicationJob
  queue_as :default

  def perform(*)
    Project.all.each(&:check_alerts)
    Person.all.each(&:check_alerts)
  end
end
