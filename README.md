# HeavenNotifier [![Build Status](https://travis-ci.org/atmos/heaven-notifier.png?branch=master)](https://travis-ci.org/atmos/heaven-notifier)

HeavenNotifier relays messages from GitHub's [deployment status API](http://developer.github.com/v3/repos/deployments/#deployment-statuses) to a chat service of your choice.

![](http://cloudapp.atmos.org/image/1M1D2t1O2F15/Slack%202014-02-25%2020-34-13%202014-02-25%2020-34-15.jpg)

This is an event funnel for deployment activity. You will have lots of systems doing deployments, and this is the part that routes info back via your preferred protocol. Go nuts.

# Notifiers

HeavenNotifier supports two chat services, [SlackHQ](https://slack.com/) and [Campfire](https://campfirenow.com/). It favors slackHQ if the appropriate environmental variables are present.

## SlackHQ

* `SLACK_TOKEN`: The token from slack's [incoming webhooks](https://tlc.slack.com/services/new/incoming-webhook) integration.
* `SLACK_SUBDOMAIN`: The default subdomain for your team.

## Campfire

* `CAMPFIRE_TOKEN`: The token to send messages to campfire
* `CAMPFIRE_SUBDOMAIN`: The default subdomain to post campfire messages to

# Hosting on heroku

## Required Setup

* Access to a redis server for resque job processing.
* OAuth application setup to authenticate against GitHub.
* A GitHub team that's allowed to view the resque queues.

## CLI Setup

    $ heroku addons:add openredis:micro
    $ heroku ps:scale worker=1
    $ heroku config:add GITHUB_CLIENT_ID=<key>
    Setting config vars and restarting heroku-deployer... done, v8
    GITHUB_CLIENT_ID: <key>
    $ heroku config:add GITHUB_CLIENT_SECRET=<secret>
    Setting config vars and restarting heroku-deployer... done, v9
    GITHUB_CLIENT_SECRET: <secret>
    $ heroku config:add RAILS_SECRET_KEY_BASE=`ruby -rsecurerandom -e "print SecureRandom.hex"`
    RAILS_SECRET_KEY_BASE: <secret>
    $ heroku config:add GITHUB_TEAM_ID=<teamid>
    GITHUB_TEAM_ID: <teamid>

# See Also

* [heaven](https://github.com/atmos/heaven)
* [hubot-deploy](https://github.com/atmos/hubot-deploy)
