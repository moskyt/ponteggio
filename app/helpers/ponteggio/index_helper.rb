module Ponteggio
  module IndexHelper
  
    def index_table_for(record_set, index_column_set)
      content_tag :table do
        content_tag :tbody do
          record_set.map do |record|
            content_tag :tr do
              index_column_set.map do |column|
                content_tag :td do
                  value_for(record, column)
                end
              end * "\n"
            end
          end * "\n"
        end
      end
    end
    
    def index_links_box(model_class)
      link_to(t('ponteggio.links.new'), polymorphic_url(model_class.new, :action => :new))
    end
  
  end
end