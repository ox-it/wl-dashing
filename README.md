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

Ideas:

* RT Tickets - Open Today, Closed Today
* status.ox.ac.uk - Parse WebLearn Status.
* github commits today - Github API
* jira issues closed - Jira API
* jenkins build status
