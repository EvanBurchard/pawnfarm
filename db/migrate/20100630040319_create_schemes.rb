class CreateSchemes < ActiveRecord::Migration
  def self.up
    create_table :schemes do |t|
      t.references :scheme_type
      t.references :pawn
      t.string :target
      t.string :prompt
      t.boolean :random_interval
      t.integer :frequency

      t.timestamps
    end
  end

  def self.down
    drop_table :schemes
  end
end
