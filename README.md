# Heaven Notifier

Send DeploymentStatus events to your chat network of choice.

# Running Locally

    $ bundle install --local --path vendor/gems
    $ bundle exec foreman

# Hosting on heroku

## Environmental Variables

* `GITHUB_TEAM_ID`: The GitHub team id to restrict resque access to.
* `CAMPFIRE_TOKEN`: The token to send messages to campfire
* `CAMPFIRE_SUBDOMAIN`: The default subdomain to post campfire messages to
* `RAILS_SECRET_KEY_BASE`: The key configured in [secret_token.rb](/config/initializers/secret_token.rb).
