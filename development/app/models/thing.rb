class Thing < ActiveRecord::Base
  
  include Ponteggio::EnumeratedColumn
  
  has_many :pieces
  
  enumeration :kind, 'kindA', 'kindB'
  
  def to_s
    "##{id}:#{title}"
  end
  
end
