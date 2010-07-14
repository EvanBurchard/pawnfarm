class Pawn < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :schemes
  has_many :executions, :dependent => :destroy
  validates_presence_of :name
  validates_presence_of :twitter_username
  validates_presence_of :twitter_password
  has_one :twitter_account, :dependent => :destroy
  
  
  def self.execute!
    @pawns = Pawn.find_all_by_active(true)
    @pawns.each do |p| 
      p.create_executions!
      p.execute! 
    end
  end 

  def execute!
    executions.each { |e| e.execute! }
  end
  
  def create_executions!
    schemes.each do |s|
      @executions = s.executions
      unless (@executions.map {|e| e.pawn }).include?(self) 
        Execution.create(:scheme => s, :pawn => self)
      end
    end
  end
  
  def tweet
    #twitter_account.tweet
  end
  
  def setup_twitter_account
    TwitterAccount.create!(:username => twitter_username, :password => twitter_password, :pawn_id => self.id)
  end
end
