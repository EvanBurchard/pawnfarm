class Scheme < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :pawns
  validates_presence_of :user_id
  validates_presence_of :title
  validates_presence_of :type  

  def self.select_options
    ["TweetScheme", "RTScheme", "AtScheme"]
  end

  @child_classes = []

  def self.inherited(child)
    @child_classes << child
    super # important!
  end

  def self.child_classes
    @child_classes
  end

  def type_helper   
    self.type 
  end 
  def type_helper=(type)   
    self.type = type
  end
  
end
