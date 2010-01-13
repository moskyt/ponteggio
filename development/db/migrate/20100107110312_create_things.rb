class CreateThings < ActiveRecord::Migration
  def self.up
    create_table :things do |t|
      t.string :title
      t.text :description
      t.text :article_body
      t.string :kind
      t.datetime :timestamp
      t.date :dateref
      t.time :timeref
      t.boolean :published

      t.timestamps
    end
  end

  def self.down
    drop_table :things
  end
end
