class Execution < ActiveRecord::Base
  belongs_to :scheme
  belongs_to :pawn
  has_many :turk_forms, :dependent => :destroy
  
  validates_presence_of :pawn_id
  validates_presence_of :scheme_id
  
  after_create :build_forms_if_needed
  
  include AASM
  aasm_column :state
  aasm_initial_state :building_forms

  aasm_state :retweeting
  aasm_state :building_forms
  aasm_state :seeking_candidates, :enter => :turk_for_candidates
  aasm_state :seeking_review_of_candidates, :enter => :turk_for_review
  aasm_state :tweeted

  aasm_event :seek_candidates do
    transitions :to => :seeking_candidates, :from => :building_forms
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
  
  def build_forms_if_needed
    if scheme.type == "RtScheme"
      retweet
    else
      build_forms
    end
  end
  
  def build_forms
    TurkForm.create(:execution => self, :body => form_body_text, :form_type => "form_a")
    TurkForm.create(:execution => self, :body => form_body_text, :form_type => "form_b")
    seek_candidates
    save
  end

  def form_body_text
    if scheme.tweet_prompt.present?
      scheme.get_status_for_tweet_prompt
    end
  end

  def turk_for_candidates
    scheme.create_executions!(pawn)
    @candidates = candidates
    @candidates.each do |c|
      @hit = create_hit(c)
      c.update_attribute(:url, @hit.url)
      c.update_attribute(:hit_id, @hit.hit_id)
    end
  end

  def candidates
    [form_a, form_b]
  end
  
  def form_a 
    turk_forms.select {|t| t.execution == self and t.form_type == "form_a"}.first
  end
  
  def form_b 
    turk_forms.select {|t| t.execution == self and t.form_type == "form_b"}.first
  end

  def create_hit(turk_form)
    hit = RTurk::Hit.create(:title => "Write a tweet for me (#{Time.now.to_s})") do |hit|
      hit.description = "Write a twitter update"
      hit.reward = 0.02
      hit.assignments = 1
      hit.question("http://pawnfarm.com/turk_forms/#{turk_form.id}")
    end             
  end

  def candidates_found?
    hits = RTurk::Hit.all_reviewable
    unless hits.empty?
      hits.each do |hit|
        if hit.id == form_a.hit_id
          if hit.assignments.present?
            self.update_attribute(:candidate_a, hit.assignments.first.answers['tweet'])
            hit.assignments.first.approve!
            hit.dispose!
          end
        end
        if hit.id == form_b.hit_id
          if hit.assignments.present?
            self.update_attribute(:candidate_b, hit.assignments.first.answers['tweet'])
            hit.assignments.first.approve!
            hit.dispose!
          end
        end
      end        
    end
    (candidate_a.present? and candidate_b.present?) ? true : false
  end

  def found_candidates
    build_review_form
    seek_candidate_review
    save
  end

  def build_review_form
    if turk_forms.size < 3
      turk_forms.build(:form_type => "review")
    end
  end
  
  def review_form
    turk_forms.select{|t| t.execution == self and t.form_type == "review"}.first
  end

  def create_review_hit
    hit = RTurk::Hit.create(:title => "Which response is better? (#{Time.now.to_s})") do |hit|
      hit.description = "Choose the better response given the prompt"
      hit.reward = 0.02
      hit.assignments = 1
      hit.question("http://pawnfarm.com/turk_forms/#{review_form.id}")
    end    
  end
  
  def turk_for_review
    @turk_form = review_form
    @hit = create_review_hit
    @turk_form.update_attribute(:url, @hit.url)
    @turk_form.update_attribute(:hit_id, @hit.hit_id)
  end
      
  

  def winner_found?
    #winner = klsfdjsd
    #if winner.present?
    true
  end
  
  def found_winner
    update_attribute(:winner, candidate_a)
    tweet_winner
  end
  
  def tweet_winner
    if time_to_tweet?
      update_attribute(:tweeted_at, Time.now)
      tweet
      pawn.tweet
    end
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
        (time < (e.tweeted_at + scheme.frequency.hours)) ? time : e.tweeted_at + scheme.frequency.hours
      end
    end
  end

end
