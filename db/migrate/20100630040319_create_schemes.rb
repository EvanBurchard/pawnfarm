class CreateSchemes < ActiveRecord::Migration
  def self.up
    create_table :schemes do |t|
      t.string :type
      t.references :pawn
      t.boolean :random_interval
      t.integer :frequency

      t.timestamps
    end
  end

  def self.down
    drop_table :schemes
  end
end
