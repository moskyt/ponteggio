class AddTranslatedColumnToPieces < ActiveRecord::Migration
  def self.up
    Piece.create_translation_table! :local_name => :string
  end

  def self.down
    Piece.drop_translation_table!
  end
end
