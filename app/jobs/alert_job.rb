class AlertJob
  include Sidekiq::Worker

  def perform(*)
    #puts "Rutina cada 1 minuto (job) #{Time.now}"
    #UserProject.create(notification_active: true, not_seen:false, project_id: 100)

    Project.all.each do |p|
      p.check_alerts
    end
    #ActionCable.server.broadcast "web_channel", content: "Mensaje un min #{Time.now}"
  end
end

Sidekiq::Cron::Job.create(name: 'Check alerts (creado desde job) - every 1min', cron: '* * * * *', class: 'AlertJob')