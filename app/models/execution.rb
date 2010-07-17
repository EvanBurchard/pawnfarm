#when to clear assignments/forms?

class Execution < ActiveRecord::Base
  belongs_to :scheme
  belongs_to :pawn
  has_many :turk_forms, :dependent => :destroy
  
  validates_presence_of :pawn_id
  validates_presence_of :scheme_id
  
  after_create :build_form_if_needed
  
  include AASM
  aasm_column :state
  aasm_initial_state :building_form

  aasm_state :retweeting
  aasm_state :building_form
  aasm_state :seeking_candidates, :enter => :turk_for_candidates
  aasm_state :seeking_review_of_candidates, :enter => :turk_for_review
  aasm_state :tweeted

  aasm_event :seek_candidates do
    transitions :to => :seeking_candidates, :from => :building_form
  end
  
  aasm_event :seek_candidate_review do
    transitions :to => :seeking_review_of_candidates, :from => :seeking_candidates  
  end
  aasm_event :tweet do
    transitions :to => :tweeted, :from => [:seeking_review_of_candidates, :retweeting], :guard => :time_to_tweet?
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
  
  def retweet
    pawn.retweet(scheme.target_account)
    tweet
    if state == "tweeted"
      update_attribute(:tweeted_at, Time.now)
    end
  end
  
  def build_form_if_needed
    if scheme.type == "RtScheme"
      retweet
    else
      build_form
    end
  end
  
  def build_form
    @turk_form = TurkForm.new(:execution => self, :body => form_body_text)
    @turk_form.save
    seek_candidates
    save
  end

  def form_body_text
    if scheme.tweet_prompt.present?
        "#{scheme.get_status_for_tweet_prompt}"
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
    update_attribute(:tweeted_at, Time.now)
    tweet
    pawn.tweet
  end

  def time_to_tweet?
    Time.now <= when_to_tweet
  end
  
  def when_to_tweet
    @executions = Execution.find_all_by_pawn_id_and_scheme_id(pawn.id, scheme.id)
    @executions.map {|e| @executions.delete(e) if e.tweeted_at.blank?}
    if @executions.blank?
      Time.now
    else
      @executions.inject(Time.now) do |time, e|
        (time < (e.tweeted_at + scheme.tweet_frequency.hours)) ? time : e.tweeted_at + scheme.tweet_frequency.hours
      end
    end
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
  # aasm_event :failure do
  #   transitions :to => :building_form
  # end

end
