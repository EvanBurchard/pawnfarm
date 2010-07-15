class TwitterAccount < ActiveRecord::Base
  belongs_to :pawn
  validates_presence_of :pawn_id
  validates_presence_of :username
  validates_presence_of :password
  
  def self.oauth
    @oauth ||= Twitter::OAuth.new("FLZ8YtbDLHMEWai08DbVQ", "u4XTsn5NV2NAzezQ48JnWrvrKwPNn3pbsMPO33EkVU", :sign_in => true)
  end
  def authorize_from_access
    TwitterAccount.oauth.authorize_from_access(access_key, access_secret)
  end
  def set_client
    Twitter::Base.new(authorize_from_access)    
  end
  
end
