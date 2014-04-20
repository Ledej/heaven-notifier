worker_processes 3
timeout 30
preload_app true

@resque_pid = nil

before_fork do |server, worker|
  if defined?(Resque)
    Resque.redis.quit
    Rails.logger.info("Disconnected from Redis")
  end
end

after_fork do |server, worker|
  if defined?(Resque)
    HeavenNotifier.redis_reconnect!
    Rails.logger.info("Connected to Redis")
    @resque_pid ||= spawn("QUEUES=* bundle exec rake resque:work")
  end
end
