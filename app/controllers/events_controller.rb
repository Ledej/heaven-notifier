class EventsController < ApplicationController

  def create
    request.body.rewind
    data = request.body.read

    guid  = request.headers['HTTP_X_GITHUB_DELIVERY']
    event = request.headers['HTTP_X_GITHUB_EVENT']

    json_body = JSON.parse(data)
    Rails.logger.info "Found #{json_body['event']}"

    if json_body['event'] == 'deployment_status'
      HeavenNotifier.redis.set "data", JSON.dump(json_body)
    end
    Resque.enqueue(Receiver, event, guid, data)
    render :status => 201, :json => "{}"
  end
end
