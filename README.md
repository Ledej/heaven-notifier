# HeavenNotifier

Heaven notifier relays messages from GitHub's [deployments API](http://developer.github.com/v3/repos/deployments/) to a chat service of your choice.

# Running Locally

    $ bundle install --local --path vendor/gems
    $ bundle exec foreman

# Notifiers

Heaven notifier supports two chat services, [SlacHQ](https://slack.com/) and [Campfire](https://campfirenow.com/). It favors slackHQ if the appropriate environmental variables are present.

## SlackHQ

* `SLACK_TOKEN`: The token from slack's [incoming webhooks](https://tlc.slack.com/services/new/incoming-webhook) integration.
* `SLACK_SUBDOMAIN`: The default subdomain for your team.

## Campfire

* `CAMPFIRE_TOKEN`: The token to send messages to campfire
* `CAMPFIRE_SUBDOMAIN`: The default subdomain to post campfire messages to

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
* `RAILS_SECRET_KEY_BASE`: The key configured in [secret_token.rb](/config/initializers/secret_token.rb).
