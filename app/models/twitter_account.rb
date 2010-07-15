class TwitterAccount < ActiveRecord::Base
  belongs_to :pawn
  validates_presence_of :pawn_id
  validates_presence_of :username
  validates_presence_of :password
  
  def set_client
    @oauth ||= Twitter::OAuth.new("FLZ8YtbDLHMEWai08DbVQ", "u4XTsn5NV2NAzezQ48JnWrvrKwPNn3pbsMPO33EkVU", :sign_in => true)
    @oauth.authorize_from_access(access_key, access_secret)
    Twitter::Base.new(@oauth)    
  end
  
end
