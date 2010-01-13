class CreatePieces < ActiveRecord::Migration
  def self.up
    create_table :pieces do |t|
      t.integer :thing_id
      t.string :title
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :pieces
  end
end
