# Heaven Notifier

Send DeploymentStatus events to your chat network of choice.

# Running Locally

    $ bundle install --local --path vendor/gems
    $ bundle exec foreman

# Hosting on heroku

    $ heroku addons:add openredis:micro
    $ heroku ps:scale worker=2
    $ heroku config:add GITHUB_CLIENT_ID=<key>
    Setting config vars and restarting heroku-deployer... done, v8
    GITHUB_CLIENT_ID: <key>
    $ heroku config:add GITHUB_CLIENT_SECRET=<secret>
    Setting config vars and restarting heroku-deployer... done, v9
    GITHUB_CLIENT_SECRET: <secret>
    $ heroku config:add RAILS_SECRET_KEY_BASE=`ruby -rsecurerandom -e "print SecureRandom.hex"`
    RAILS_SECRET_KEY_BASE: <secret>

## Environmental Variables

* `GITHUB_TEAM_ID`: The GitHub team id to restrict resque access to.
* `CAMPFIRE_TOKEN`: The token to send messages to campfire
* `CAMPFIRE_SUBDOMAIN`: The default subdomain to post campfire messages to
* `RAILS_SECRET_KEY_BASE`: The key configured in [secret_token.rb](/config/initializers/secret_token.rb).
