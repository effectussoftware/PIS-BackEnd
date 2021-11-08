class AlertJob
  include Sidekiq::Worker

  def perform(*)
    Project.all.each(&:check_alerts)
    Person.all.each(&:check_alerts)
  end
end

Sidekiq::Cron::Job.create!(name: 'Check alerts (creado desde job) - every 1min', cron: '* * * * *',
                           class: 'AlertJob')
