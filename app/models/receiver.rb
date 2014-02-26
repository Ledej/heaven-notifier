class Receiver
  @queue = :events

  attr_accessor :event, :guid, :payload, :token

  def initialize(event, guid, payload)
    @guid    = guid
    @event   = event
    @token   = ENV['GITHUB_DEPLOY_TOKEN'] || '<unknown>'
    @payload = payload
  end

  def data
    @data ||= JSON.parse(payload)
  end

  def run!
    return unless supported_event?

    notifier = Notifier.new(data)
    notifier.post!(data)
  end

  def self.perform(event, guid, data)
    new(event, guid, data).run!
  end

  def supported_event?
    %w(deployment_status).include?(event)
  end
end
