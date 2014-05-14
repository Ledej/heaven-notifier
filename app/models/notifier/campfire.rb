module Notifier
  class Campfire < Notifier::Default
    def deliver(message)
      message << " #{output_link('Output')}"
      Rails.logger.info "campfire: #{message}"
      room = campfire_account.room_by_id(chat_room)
      room.message(message)
    end

    def campfire_token
      ENV['CAMPFIRE_TOKEN'] || '0xdeadbeef'
    end

    def campfire_subdomain
      ENV['CAMPFIRE_SUBDOMAIN'] || 'unknown'
    end

    def campfire_account
      @campfire_account ||= Campfiyah::Account.new(campfire_subdomain, token)
    end
  end
end
