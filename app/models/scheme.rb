class Scheme < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :pawns
  has_many :executions, :dependent => :destroy
  validates_presence_of :user_id
  validates_presence_of :title
  validates_presence_of :type  

  def get_status_for_tweet_prompt
    if tweet_prompt_relationship == "followers"
      @twitter_login_or_id = random_follower
    elsif tweet_prompt_relationship == "friends"      
      @twitter_login_or_id = random_friend
    else
      @twitter_login_or_id = tweet_prompt    
    end
    @message = get_status(@twitter_login_or_id)
    "Your friend has just said #{@message}"
  end

  def get_status(twitter_login_or_id)
    Twitter.user(twitter_login_or_id).status.text
  end
  
  def random_friend
    friend_ids = Twitter.friend_ids(tweet_prompt)
    friend_ids[rand(follower_ids.size)]
  end
  def random_follower
    follower_ids = Twitter.follower_ids(tweet_prompt)
    follower_ids[rand(follower_ids.size)]
  end

  def create_executions!(pawn)
    if self == RtScheme
      Execution.create(:scheme => self, :pawn => pawn)
    else
      unless (executions.map {|e| e.pawn }).include?(pawn) 
        Execution.create(:scheme => self, :pawn => pawn)
      end
    end
  end

  def self.select_options
    ["TweetScheme", "RtScheme", "AtScheme"]
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
