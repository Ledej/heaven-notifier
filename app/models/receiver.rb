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
    notifier = Notifier.for(data)
    notifier.post!(data)
  end

  def self.perform(event, guid, data)
    return unless event == "deployment_status"

    new(event, guid, data).run!
  end
end
