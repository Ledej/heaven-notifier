module ApplicationHelper
  def incoming_ip_valid?(ip)
    return true if ["127.0.0.1", "0.0.0.0"].include?(ip) && Rails.env == "test"
    hook_source_ips.any? { |block| IPAddr.new(block).include?(ip) }
  end

  private
    def hook_source_key
      @hook_source_key ||= "hook-sources-#{Rails.env}"
    end

    def default_ttl
      %w(staging production).include?(Rails.env) ? 60 : 2
    end

    def hook_source_ips
      if addresses = Heaven.redis.get(hook_source_key)
        JSON.parse(addresses)
      else
        addresses = Octokit::Client.new.get("/meta").hooks
        Heaven.redis.set(hook_source_key, JSON.dump(addresses))
        Heaven.redis.expire(hook_source_key, default_ttl)
        Rails.logger.info "Refreshed GitHub hook sources"
        addresses
      end
    end
end
