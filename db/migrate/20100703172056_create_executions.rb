class CreateExecutions < ActiveRecord::Migration
  def self.up
    create_table :executions do |t|
      t.references :scheme
      t.references :pawn
      t.string :state
      t.string :candidate_a
      t.string :candidate_b
      t.string :winner

      t.timestamps
    end
  end

  def self.down
    drop_table :executions
  end
end
