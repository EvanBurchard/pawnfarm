class Pawn < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :schemes
  has_many :executions
  validates_presence_of :name
  
  def tweet
    
  end
end
