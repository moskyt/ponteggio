class CreateSimpleThings < ActiveRecord::Migration
  def self.up
    create_table :simple_things do |t|
      t.string :title
      t.text :body
      t.datetime :timestamp
      t.time :timeref
      t.date :dateref

      t.timestamps
    end
  end

  def self.down
    drop_table :simple_things
  end
end
