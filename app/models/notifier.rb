class Notifier
  attr_accessor :payload

  def initialize(payload)
    @payload = payload
  end

  def ascii_face
    case state
    when "pending"
      "•̀.̫•́✧"
    when "success"
      "(◕‿◕)"
    when "failure"
      "ಠﭛಠ"
    when "error"
      "¯_(ツ)_/¯"
    else
      "٩◔̯◔۶"
    end
  end

  def pending?
    state == "pending"
  end

  def green?
    %w(pending success).include?(state)
  end

  def deliver(message)
    if slack_token
      output_message   = Slack::Notifier::LinkFormatter.format(output_link('Logs'))
      filtered_message = Slack::Notifier::LinkFormatter.format(message + " #{ascii_face}")

      Rails.logger.info "slack: #{filtered_message}"

      slack_account.ping "",
        :channel     => "##{chat_room}",
        :username    => "Shipping #{repo_name}",
        :icon_url    => "https://octodex.github.com/images/labtocat.png",
        :attachments => [{
          :text    => filtered_message,
          :color   => green? ? "good" : "danger",
          :pretext => pending? ? output_message : " "
        }]
    else
      message << " #{output_link('Output')}"
      Rails.logger.info "campfire: #{message}"
      room = campfire_account.room_by_id(chat_room)
      room.message(message)
    end
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

  def slack_token
    ENV['SLACK_TOKEN']
  end

  def slack_subdomain
    ENV['SLACK_SUBDOMAIN'] || 'unknown'
  end

  def slack_account
    @slack_account ||= Slack::Notifier.new(slack_subdomain, slack_token)
  end

  def custom_payload
    @custom_payload ||= payload['payload']
  end

  def state
    payload['state']
  end

  def number
    payload['id']
  end

  def sha
    payload['sha'][0..7]
  end

  def deployment_number
    if matches = payload['deployment_url'].match(/.*\/(\d+)/)
      matches[1]
    else
      0
    end
  end

  def commitish
    payload['ref']
  end

  def environment
    payload['environment']
  end

  def target_url
    payload['target_url']
  end

  def chat_user
    custom_payload['notify']['user'] || "unknown"
  end

  def chat_room
    custom_payload['notify']['room']
  end

  def repo_name
    custom_payload['name'] || payload['repository']['name']
  end

  def repo_url(path = "")
    payload['repository']['html_url'] + path
  end

  def user_link
    "[#{chat_user}](https://github.com/#{chat_user})"
  end

  def output_link(link_title = "deployment")
    "[#{link_title}](#{target_url})"
  end

  def repository_link(path = "")
    "[#{repo_name}](#{repo_url(path)})"
  end

  def post!(payload)
    message = user_link
    case state
    when 'success'
      message << "'s #{environment} deployment of #{repository_link} is done! "
    when 'failure'
      message << "'s #{environment} deployment of #{repository_link} failed. "
    when 'pending'
      message << " is deploying #{repository_link("/tree/#{commitish}")} to #{environment}"
    else
      puts "Unhandled deployment state, #{state}"
    end
    deliver(message)
  end
end
