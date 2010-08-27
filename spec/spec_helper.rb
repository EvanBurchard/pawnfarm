# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path(File.join(File.dirname(__FILE__),'..','config','environment'))
require 'spec/autorun'
require 'spec/rails'
require 'shoulda'
require 'factory_girl'
require 'factories'

# Uncomment the next line to use webrat's matchers
#require 'webrat/integrations/rspec-rails'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir[File.expand_path(File.join(File.dirname(__FILE__),'support','**','*.rb'))].each {|f| require f}

Spec::Runner.configure do |config|
  # If you're not using ActiveRecord you should remove these
  # lines, delete config/database.yml and disable :active_record
  # in your config/boot.rb
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  config.fixture_path = RAILS_ROOT + '/spec/fixtures/'
  FakeWeb.allow_net_connect = false
  
  FakeWeb.register_uri(:get, %r|http:\/\/api.twitter.com\/oauth\/authorize\?oauth_token=\S*|, :body => "Allow PawnFarm access?")
  FakeWeb.register_uri(:post, 'http://api.twitter.com/oauth/request_token', :body => 'oauth_token=fake&oauth_token_secret=fake')
  FakeWeb.register_uri(:get, 'http://api.twitter.com/1/users/show/.json', :body => {:status => {:text => "some message"}})
  FakeWeb.register_uri(:get, %r|http:\/\/mechanicalturk.sandbox.amazonaws.com\S*|, :body => "<?xml version=\"1.0\"?>\n<CreateHITResponse><OperationRequest><RequestId>3e8b4269-d287-4d1c-bb82-2dd352c6b0d2</RequestId></OperationRequest><HIT><Request><IsValid>True</IsValid></Request><HITId>1S5VPD4ZD25QFAPM4LHERZFYQE1528</HITId><HITTypeId>18EPHS476DW6VB2R81AQ5172Z9WCKZ</HITTypeId></HIT></CreateHITResponse>", :status => ["200", "OK"])
end
