class Scheme < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :pawns
  validates_presence_of :user_id
  validates_presence_of :title
  validates_presence_of :type  
  
  def self.select_options
    subclasses.map{ |c| c.to_s }.sort
  end

  @child_classes = []

  def self.inherited(child)
    @child_classes << child
    super # important!
  end

  def self.child_classes
    @child_classes
  end

  
end
