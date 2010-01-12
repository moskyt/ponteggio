module Ponteggio
  module PageHelper
  
    def index_page_for(model_class, record_set, index_column_set)
      content_tag(:h1, model_class.human_name(:count => 999)) + 
      index_table_for(model_class, record_set, index_column_set) + 
      index_links_box(model_class)
    end
    
    def new_page_for(model_class, record, edit_column_set)
      content_tag(:h1, model_class.human_name) +
      ponteggio_form_for(record, edit_column_set)
    end
    
    def edit_page_for(record, edit_column_set)
      content_tag(:h1, record.class.human_name + ' :: ' + record.to_s) +
      ponteggio_form_for(record, edit_column_set) + 
      edit_links_box(record)
    end

    def show_page_for(record, show_column_set)
      content_tag(:h1, record.class.human_name + ' :: ' + record.to_s) +
      show_table_for(record, show_column_set) + 
      show_links_box(record)
    end
  
  end
end