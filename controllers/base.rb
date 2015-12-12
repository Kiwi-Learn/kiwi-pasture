require 'sinatra/base'
require 'active_support'
require 'active_support/core_ext'

require 'config_env'
require 'aws-sdk'
require 'dalli'

class KiwiPasture < Sinatra::Base
  configure :development, :test do
    ConfigEnv.path_to_config("#{__dir__}/../config/config_env.rb")
    set :api_server, 'http://localhost:9292'
  end

  configure :development do
    # ignore if not using shotgun in development
    set :session_secret, "fixed secret"
  end

  configure :production do
    set :api_server, 'https://kiwi-pasture.herokuapp.com/'
  end

  configure :production, :development do
    enable :logging
  end

  configure do
    set :api_ver, 'api/v2'
  end

  before do
    @HOST_WITH_PORT = request.host_with_port
  end
end
