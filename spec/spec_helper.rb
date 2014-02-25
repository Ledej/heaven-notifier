# Environmental variables set at runtime
ENV["RAILS_ENV"]             ||= 'test'
ENV["RAILS_SECRET_KEY_BASE"] ||= SecureRandom.uuid

# Get the environment going
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_base_class_for_anonymous_controllers = false
  config.order = "random"
  
  config.before do
    Resque.inline = true
    Campfiyah.enable_mock!
  end

  def fixture_data(name)
    File.read(File.join(File.dirname(__FILE__), "fixtures", "#{name}.json"))
  end

  def default_headers(event)
    {
      'ACCEPT'                 => 'application/json' ,
      'CONTENT_TYPE'           => 'application/json',
      'HTTP_X_GITHUB_EVENT'    => event,
      'HTTP_X_GITHUB_DELIVERY' => SecureRandom.uuid
    }
  end
end
