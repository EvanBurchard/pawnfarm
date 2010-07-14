#when to clear assignments/forms?

class Execution < ActiveRecord::Base
  belongs_to :scheme
  belongs_to :pawn
  has_many :turk_forms
  
  validates_presence_of :pawn
  validates_presence_of :scheme
  
  # after_create :build_form
  
  include AASM
  aasm_column :state
  aasm_initial_state :building_form
  
  aasm_state :building_form
  aasm_state :seeking_candidates, :enter => :turk_for_candidates
  aasm_state :seeking_review_of_candidates, :enter => :turk_for_review
  aasm_state :tweeted#, :enter => :cleanup_and_replicate

  aasm_event :seek_candidates do
    transitions :to => :seeking_candidates, :from => :building_form
  end
  
  aasm_event :seek_candidate_review do
    transitions :to => :seeking_review_of_candidates, :from => :seeking_candidates  
  end
  aasm_event :tweet do
    transitions :to => :tweeted, :from => :seeking_review_of_candidates
  end
  
  def execute!
    if state == "seeking_candidates"
      if candidates_found?
        found_candidates
      end
    elsif state == "seeking_review_of_candidates"
      if winner_found?
        found_winner
      end
    end
  end
  
  def build_form
    @turk_form = TurkForm.new(:execution => self, :body => form_body_text)
    @turk_form.save
    seek_candidates
    save
  end

  def form_body_text
    if scheme.tweet_prompt
      if scheme.prompt
        scheme.prompt + "#{scheme.get_status_for_tweet_prompt}  Respond in 120 characters."      
      else
        "#{scheme.get_status_for_tweet_prompt}  Respond in 120 characters."
      end
    else
      if scheme.prompt
        scheme.prompt
      else
        "Create a message 120 characters long."
      end
    end
  end
  
  def found_candidates
    build_review_form
    seek_candidate_review
  end

  def build_review_form
    @turk_form = TurkForm.new(:execution => self)
    @turk_form.save    
  end
  
  def turk_for_review
    # present form url to turk     
  end
    
  def turk_for_candidates
    # present form url to turk 
  end
  
  def candidates_found?
    if (candidate_a.present? and candidate_b.present?)
      true
    end
  end

  def winner_found?
    true
  end
  
  def found_winner
    self.winner = "candidate a"
    self.save
    tweet_winner
  end
  
  def tweet_winner
    tweet
    pawn.tweet
  end

  # def cleanup_and_replicate
  #   clear_tasks_and_forms
  #   spawn_new_execution
  # end  
  # def clear_tasks_and_forms
  # end
  # def spawn_new_execution
  # end
  # 
  # 
  # def cannot_find_winner
  #   failure
  # end
  # 
  # def cannot_find_candidates
  #   failure
  # end
  # 
  # def pawn_recently_tweeted?
  #   Time.now < pawn.last_tweet_time + pawn.tweet_frequency.hours  
  # end
  # aasm_event :failure do
  #   transitions :to => :building_form
  # end

end
