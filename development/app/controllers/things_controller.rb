class ThingsController < ApplicationController
  
  ponteggio Thing, :crud
  index_column_set :title, :kind, :description, :pieces
#  edit_column_set  :title, :kind, :description, :article_body, :pieces
  
  column :title, :sortable => true
  column :article_body, :kind => :wysiwyg
  column :pieces, :list => :long, :style => :dropdown
  
  items_per_page 22
  
end
