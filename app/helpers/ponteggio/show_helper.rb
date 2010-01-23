module Ponteggio
  module ShowHelper

    def show_links_box(record)
      content_tag :div, :class => 'ponteggio-show-links' do
        content_tag :span, :class => 'ponteggio-show-links' do
          link_to(t('ponteggio.links.index'), polymorphic_url(record.class.new)) + ' | ' +
          link_to(image_tag('ponteggio/page_edit.png'), polymorphic_url(record, :action => :edit))
        end
      end
    end
    
    def show_table_for(record, show_column_set)
      content_tag :table, :class => 'ponteggio-show' do
        content_tag :tbody do
          show_column_set.map do |column|
            content_tag(:tr) do
              content_tag(:td, column[:name] + ': ', :class => 'label') +
              content_tag(:td, value_for(record, column), :class => 'value')
            end
          end * "\n"
        end
      end
    end
    
    def show_list_for(record, show_column_set)
      show_column_set.map do |column|
        content_tag(:p, :class => 'ponteggio-show') do
          content_tag(:span, column[:name] + ': ', :class => 'label') +
          ((column[:list] == :long) ? '<br />' : '') + 
          value_for(record, column)
        end
      end * "\n"
    end
    
  end
end