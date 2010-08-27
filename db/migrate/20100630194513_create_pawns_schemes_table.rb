class CreatePawnsSchemesTable < ActiveRecord::Migration
  def self.up
    create_table :pawns_schemes, :id => false do |t|
      t.column :pawn_id, :integer, :null => false
      t.column :scheme_id,  :integer, :null => false
    end
  end

  def self.down
    drop_table :pawns_schemes
  end
end
