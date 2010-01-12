module Ponteggio
  module ShowHelper

    def show_links_box(record)
      link_to(t('ponteggio.links.index'), polymorphic_url(record.class.new)) + ' | ' +
      link_to(image_tag('ponteggio/page_edit.png'), polymorphic_url(record, :action => :edit))
    end
    
    def show_table_for(record, show_column_set)
      show_column_set.map do |column|
        content_tag(:p) do
          content_tag(:strong, column[:name] + ': ') +
          ((column[:list] == :long) ? '<br />' : '') + 
          value_for(record, column)
        end
      end * "\n"
    end
    
  end
end