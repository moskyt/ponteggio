class Piece < ActiveRecord::Base
    
  include Ponteggio::EnumeratedColumn
  
  belongs_to :thing
  translates :local_name  

  def to_s
    "##{id}:#{title}"
  end
  
end
