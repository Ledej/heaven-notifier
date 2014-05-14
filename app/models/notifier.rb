module Notifier
  def self.for(payload)
    if slack?
      Notifier::Slack.new(payload)
    elsif hipchat_token
      Notifier::Hipchat.new(payload)
    else
      Notifier::Campfire.new(payload)
    end
  end

  def self.slack?
    !!ENV['SLACK_TOKEN']
  end

  def self.hipchat?
    !!ENV['HIPCHAT_TOKEN']
  end
end
