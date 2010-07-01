require 'spec_helper'

describe Scheme do
  it { should have_and_belong_to_many(:pawns) }
  it { should belong_to(:user) }

  # it { should validate_inclusion_of(:type, :in => %w(rt_scheme, at_scheme, tweet_scheme  )}
  it { should validate_presence_of(:type) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:user_id) }
  
  it { should have_db_column(:title).of_type(:string).with_options(:null => false) }
  it { should have_db_column(:description).of_type(:string) }
  it { should have_db_column(:type).of_type(:string) }
  it { should have_db_column(:user_id).of_type(:integer) }
  it { should have_db_column(:random_interval).of_type(:boolean) }
  it { should have_db_column(:frequency).of_type(:integer) }
  it { should have_db_column(:created_at).of_type(:datetime) }
  it { should have_db_column(:updated_at).of_type(:datetime) }
  it { should have_db_column(:tweet_prompt) }
  it { should have_db_column(:tweet_prompt_relationship) }
  it { should have_db_column(:prompt) }
  it { should have_db_column(:target) }
  it { should have_db_column(:target_relationship) }        

end
