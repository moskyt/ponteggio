module Ponteggio
  module PageHelper
  
    def index_page_for(model_class, record_set, index_column_set)
      content_tag(:h1, model_class.human_name(:count => 999)) + 
      index_table_for(record_set, index_column_set) + 
      index_links_box(model_class)
    end
    
    def new_page_for(model_class, record, edit_column_set)
      content_tag(:h1, model_class.human_name) +
      ponteggio_form_for(record, edit_column_set)
    end
  
  end
end