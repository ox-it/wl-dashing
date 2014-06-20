require 'dashing'
require 'securerandom'

configure do
  set :auth_token, ENV.fetch('AUTH_TOKEN') { SecureRandom.uuid }

  unless ENV['DASHING_FORCE_SSL'].nil?
    set :force_ssl, true
    set :host, ENV['DASHING_HOST']
  end

  helpers do
    def protected!
     # Put any authentication code you want in here.
     # This method is run before accessing any resource.
    end
  end

  before do
    if settings.force_ssl && !request.secure?
      content_type :json
      halt 400, "Please use SSL at https://#{settings.host}"
    end
  end
end

map Sinatra::Application.assets_prefix do
  run Sinatra::Application.sprockets
end

run Sinatra::Application
