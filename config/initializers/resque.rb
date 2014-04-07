module HeavenNotifier
  REDIS_PREFIX = "heaven-notifier:#{Rails.env}"

  def self.redis
    @redis ||= if ENV["OPENREDIS_URL"]
                 Redis.new(:url => ENV['OPENREDIS_URL'])
               elsif ENV["BOXEN_REDIS_URL"]
                 Redis.new(:url => ENV['BOXEN_REDIS_URL'])
               else
                 Redis.new
               end
    Resque.redis = Redis::Namespace.new("#{REDIS_PREFIX}:resque", :redis => @redis)
    @redis
  end

  def self.redis_reconnect!
    @redis = nil
    redis
  end
end

# initialize early to ensure proper resque prefixes
HeavenNotifier.redis
