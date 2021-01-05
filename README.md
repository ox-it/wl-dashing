This repository is no longer used and is just preserved for reference purposes.

Check out http://shopify.github.com/dashing for more information.

Install stuff

    export PATH=/home/buckett/.gem/ruby/1.9.1/bin:$PATH
    sudo apt-get install ruby ruby-dev bundler nodejs
    bundle install

To run:

    dashing start

To define a dashing service on boot, update the variables in `dashboard` and then

    sudo cp dashboard /etc/init.d
    sudo chmod 755 /etc/init.d/dashboard
    sudo update-rc.d dashboard defaults

## Enviornment variables

The following environment variables should be set for it to run smoothly

    DASHING_JENKINS_USER
    DASHING_JENKINS_PASS
    DASHING_FORCE_SSL
    DASHING_HOST
    AUTH_TOKEN

## Ideas

* RT Tickets - Open Today, Closed Today
* status.ox.ac.uk - Parse WebLearn Status.
* github commits today - Github API
* jira issues closed - Jira API
* jenkins build status

## status.ox.ac.uk tinkering

The widget polls status.ox.ac.uk every 30 seconds for updates, but to test layout and colour you can manually send some data with:

echo '{ "auth_token": "YOUR_AUTH_TOKEN", "data": { "groups": [ {"id": "weblearn", "status_name": "Down"} ] } }' |curl -d @- http://localhost:3030/widgets/status

It would be better if the data was parsed(serverside) so we knew how long is had been at a particular status.

## AFS Quota

The AFS quota widget is updated by a script run through cron that checks the quota usage and posts the data off.
To mock this use something like:

curl -d "{ \"auth_token\": \"YOUR_AUTH_TOKEN\", \"current\": \"80\" }" http://localhost:3030/widgets/quota.afs
