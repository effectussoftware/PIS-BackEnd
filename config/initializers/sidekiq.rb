# Si no existe la variable en .env usa localhost
redis = { url: (ENV['REDIS_URL'] || 'redis://127.0.0.1') }

# Configuracion de sidekiq client; en nuestro caso el servidor puma
Sidekiq.configure_client do |config|
  config.redis = redis
end

# Configuracion de sidekiq server; El servidor que corre al ejecutar sidekiq
Sidekiq.configure_server do |config|
  config.redis = redis
end

schedule_file = 'config/schedule.yml'

# Nota: Sidekiq.server? retorna true cuando se corre desde
# el servidor de sidekiq (No con rails s). Agrego esto porque
# pensabamos que era un error
if File.exist?(schedule_file) && Sidekiq.server?
  Sidekiq.redis(&:flushdb)
  Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
end
