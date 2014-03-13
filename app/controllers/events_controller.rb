class EventsController < ApplicationController
  include ApplicationHelper
  skip_before_filter :verify_authenticity_token, :only => [:create]

  def create
    if incoming_ip_valid?(request.ip)
      request.body.rewind
      data = request.body.read

      event    = request.headers['HTTP_X_GITHUB_EVENT']
      delivery = request.headers['HTTP_X_GITHUB_DELIVERY']

      Resque.enqueue(Receiver, event, delivery, data)
      render :status => 201, :json => "{}"
    else
      Rails.logger.info "Invalid IP posting to the app, #{request.ip}"
      render :status => 404, :json => "{}"
    end
  end
end
