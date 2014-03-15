class Notifier
  attr_accessor :payload

  def initialize(payload)
    @payload = payload
  end

  def deliver(message)
    if slack_token
      filtered_message = Slack::Notifier::LinkFormatter.format(message)
      Rails.logger.info "slack: #{filtered_message}"
      slack_account.ping filtered_message, :channel => "##{chat_room}"
    else
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

  def commitish
    custom_payload['branch'] || sha
  end

  def environment
    custom_payload['environment'] || 'production'
  end

  def chat_user
    custom_payload['notify']['user'] || "unknown"
  end

  def chat_room
    custom_payload['notify']['room']
  end

  def target_url
    payload['target_url']
  end

  def repo_name
    custom_payload['name'] || payload['repository']['name']
  end

  def repo_url(path)
    payload['repository']['html_url'] + path
  end

  def user_link
    "[#{chat_user}](https://github.com/#{chat_user})"
  end

  def output_link(link_title = "deployment")
    "[#{link_title}](#{target_url})"
  end

  def repository_link
    "[#{repo_name}](#{repo_url})"
  end

  def post!(payload)
    message = user_link
    case state
    when 'success'
      message << "'s "
      if environment
        message << "#{environment} "
      end
      message << "#{output_link} of #{repository_link} is done!"
    when 'failure'
      message << "'s "
      if environment
        message << "#{environment} "
      end
      message << "#{output_link}[deployment](#{target_url}) of #{repository_link} failed."
    when 'pending'
      message << " is #{output_link('deploying')} #{repository_link("/tree/#{commitish}")}"
      if environment
        message << " to #{environment}"
      end
    else
      puts "Unhandled deployment state, #{state}"
    end
    deliver(message)
  end
end
