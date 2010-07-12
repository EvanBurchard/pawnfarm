class TwitterAccount < ActiveRecord::Base
  belongs_to :pawn
  validates_presence_of :pawn_id
  validates_presence_of :username
  validates_presence_of :password

  after_create :generate_authorize_url
  
  def generate_authorize_url
    oauth = Twitter::OAuth.new("FLZ8YtbDLHMEWai08DbVQ", "u4XTsn5NV2NAzezQ48JnWrvrKwPNn3pbsMPO33EkVU")  
    rtoken = oauth.request_token.token
    rsecret = oauth.request_token.secret
    oauth.request_token.authorize_url
  end
  
end
