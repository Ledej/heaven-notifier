ruby '2.0.0'
source 'https://rubygems.org'

gem 'rails', '4.1.0'

gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 1.2'
gem 'slack-notifier'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

group :development, :test do
  gem "pry"
  gem "sqlite3"
  gem "webmock"
  gem "debugger"
  gem "rspec-rails"
end

group :development do
  gem "foreman"
  gem "meta_request"
  gem "better_errors"
  gem "binding_of_caller"
end

group :staging, :production do
  gem "pg"
  gem "rails_12factor"
end

gem "resque"
gem "unicorn"
gem "campfiyah"
gem "yajl-ruby"
gem "warden-github-rails"
