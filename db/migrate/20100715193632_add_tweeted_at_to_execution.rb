class AddTweetedAtToExecution < ActiveRecord::Migration
  def self.up
    add_column :executions, :tweeted_at, :datetime
  end

  def self.down
    remove_column :executions, :tweeted_at
  end
end
