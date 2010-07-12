class Pawn < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :schemes
  has_many :executions
  validates_presence_of :name
  validates_presence_of :twitter_username
  validates_presence_of :twitter_password
  has_one :twitter_account
  
  after_create :setup_twitter_account
  
  def tweet
    
  end
  
  def setup_twitter_account
    TwitterAccount.create!(:username => twitter_username, :password => twitter_password, :pawn_id => self.id)
  end
end
