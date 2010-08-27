class TwitterAccount < ActiveRecord::Base
  belongs_to :pawn
  validates_presence_of :pawn_id
  validates_presence_of :username
  validates_presence_of :password
  
  def set_client
    if RAILS_ENV=="test"
      @oauth ||= Twitter::OAuth.new("API_TOKEN", "API_SECRET", :sign_in => true)
    else
      @endpoint = 'http://'+ENV['APIGEE_TWITTER_API_ENDPOINT']
      @oauth ||= Twitter::OAuth.new("API_TOKEN", "API_SECRET", :sign_in => true, :api_endpoint => @endpoint)      
    end
    @oauth.authorize_from_access(access_key, access_secret)
    Twitter::Base.new(@oauth)    
  end
  
end
