require 'spork'
require 'simplecov'

SimpleCov.start 'rails'

Spork.prefork do
  ENV["RAILS_ENV"] = "test"
  require File.expand_path('../../config/environment', __FILE__)
  require 'rails/test_help'

  class ActiveSupport::TestCase
    fixtures :all
    #def login(user_id=nil)
    #  if user_id
    #    @request.session[:user_id] = user_id
    #  else
    #    user = User.create(:twitter_id => "dummy")
    #    @request.session[:user_id] = user.id
    #  end
    #end
  end

  VCR.configure do |c|
    c.cassette_library_dir = 'test/vcr_cassettes'
    c.allow_http_connections_when_no_cassette = true
    c.hook_into :webmock # or :fakeweb
  end
end

Spork.each_run do
  load "#{Rails.root}/config/routes.rb" 
  Dir["#{Rails.root}/app/**/*.rb"].each { |f| load f }
end

