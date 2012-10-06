source "https://rubygems.org"


gem "rails" , "3.2.8"
gem "jquery-rails"
gem "uglifier"

group :production do
# gems specifically for Heroku go here
  gem "pg"
end

group :test do
  gem "minitest"
  gem 'spork'
  gem 'spork-testunit'
  gem 'vcr'
  gem 'webmock'
  gem 'simplecov',:require => false
end

group :development , :test do
  gem "sqlite3"
end

gem "json"
gem "delayed_job_active_record"
#gem "dalli"
#gem 'memcachier'

gem "rails_autolink"
#gem "rest-client"

#gem 'memcachier'
#gem 'therubyracer'
#gem 'omniauth'
#gem "omniauth-facebook"
#gem 'oauth'
#gem 'rmagick',:require => 'RMagick'
#gem 'aws-s3',:require => 'aws/s3'
#gem "kaminari"
#gem "nokogiri"

#gem "mongoid"
#gem "bson_ext"
#gem "xml-simple"
