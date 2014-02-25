class Notifier
  attr_accessor :account, :payload, :room
  def initialize(account, payload)
    @account = account
    @payload = payload
  end

  def data
    payload['payload']
  end

  def custom_payload
    @custom_payload ||= JSON.parse(data['payload'])
  end

  def state
    data['state']
  end

  def number
    data['id']
  end

  def room
    @room ||= account.room_by_id(chat_room)
  end

  def sha
    data['sha'][0..7]
  end

  def commitish
    custom_payload['branch'] || sha
  end

  def environment
    custom_payload['environment'] || 'production'
  end

  def chat_user
    custom_payload['chat']['user'] || "unknown"
  end
  
  def chat_room
    custom_payload['chat']['room']
  end

  def target_url
    data['target_url']
  end

  def repo_name
    data['repository']['name']
  end

  def post!(payload)
    message = "#{chat_user}"
    case state
    when 'success'
      message << "'s "
      if environment
        message << "#{environment} "
      end
      message << "[deployment](#{target_url}) of #{repo_name} is done!"
    when 'error'
      message << "'s "
      if environment
        message << "#{environment} "
      end
      message << "[deployment](#{target_url}) of #{repo_name} failed."
    when 'pending'
      message << " is [deploying](#{target_url}) #{repo_name}/#{commitish}"
      if environment
        message << " to #{environment}"
      end
    else
      puts "Unhandled deployment state, #{state}"
    end
    room.message(message)
  end
end
