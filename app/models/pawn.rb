class Pawn < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :schemes
  has_many :executions
  validates_presence_of :name
  has_one :twitter_account
  
  def tweet
    
  end
end
