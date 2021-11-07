# frozen_string_literal: true

# TODO
Redis.current = Redis.new(url: ENV['REDIS_URL'],
                          port: ENV['REDIS_PORT'],
                          db: ENV['REDIS_DB'])
