class PiecesController < ApplicationController
  
  ponteggio Piece, :crud
  
  index_column_set :title, :local_name, :thing
  edit_column_set :title, :local_name, :thing
  
  column :local_name, :sortable => true
    
end
