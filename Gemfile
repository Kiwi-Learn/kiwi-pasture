source 'https://rubygems.org'
ruby '2.2.3'

gem 'thin'
gem 'sinatra'
gem 'sinatra-contrib'

gem 'kiwicourse'
gem 'json'
gem 'digest'
gem 'fuzzy_match'

gem 'activerecord'
gem 'concurrent-ruby-ext'

# gems requiring credentials for 3rd party services
gem 'config_env'
gem 'aws-sdk', '~> 2'     # DynamoDB (Dynamoid), SQS Message Queue
gem 'dynamoid', '~> 1'
gem 'dalli'               # Memcachier

group :test do
  gem 'minitest'
  gem 'rack'
  gem 'rack-test'
  gem 'rake'
end

group :development, :test do
  gem 'tux'
end
