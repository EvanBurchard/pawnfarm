class CreateSchemes < ActiveRecord::Migration
  def self.up
    create_table :schemes do |t|
      t.string :type
      t.references :pawn
      t.boolean :random_interval
      t.integer :frequency
      t.string :tweet_prompt
      t.string :tweet_prompt_relationship
      t.string :prompt
      t.string :target
      t.string :target_relationship
      
      t.timestamps
    end
  end

  def self.down
    drop_table :schemes
  end
end
