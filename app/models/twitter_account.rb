class TwitterAccount < ActiveRecord::Base
  belongs_to :pawn
  validates_presence_of :pawn_id
  validates_presence_of :username
  validates_presence_of :password
  
  def set_client
    setup = YAML::load(File.open(RAILS_ROOT + 'config/setup.yml')))
    if RAILS_ENV=="test"
      @oauth ||= Twitter::OAuth.new(setup['twitter']['api_token'], setup['twitter']['api_secret'], :sign_in => true)
    else
      @endpoint = 'http://'+ (setup["twitter"]["apigee"] == 'yes' ? Env["APIGEE_TWITTER_API_ENDPOINT"] : "api.twitter.com" ) 
      @oauth ||= Twitter::OAuth.new(setup['twitter']['api_token'], setup['twitter']['api_secret'], :sign_in => true, :api_endpoint => @endpoint)      
    end
    @oauth.authorize_from_access(access_key, access_secret)
    Twitter::Base.new(@oauth)    
  end
  
end
