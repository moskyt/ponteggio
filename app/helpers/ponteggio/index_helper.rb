module Ponteggio
  module IndexHelper
  
    def index_table_for(model_class, record_set, index_column_set)
      content_tag(:table, :class => 'index-table') do
        content_tag(:colgroup) do
          index_column_set.map do |column|
            tag(:col, :width => (column[:width]))
          end * "\n" + 
          tag(:col, :width => '70')
        end + 
        index_table_header(model_class, index_column_set) +
        content_tag(:tbody) do
          record_set.map do |record|
            content_tag(:tr, :class => "index-table-row-#{cycle('odd', 'even')}") do
              index_column_set.map do |column|
                content_tag(:td) do
                  truncated_value_for(record, column)
                end
              end * "\n" + 
              content_tag(:td) do
                index_item_links(record)
              end
            end
          end * "\n"
        end + begin
          # superugly HACK to work around will_paginate
          @template = self
          def @template.request
            controller.request
          end         
          in_csv_block ||= false
  				# render the pagination control
          content_tag :tbody do
            content_tag :tr do
              content_tag(:td, :class => 'pagination', :colspan => (index_column_set.size + (in_csv_block ? 0 : 1))) do
  							if @items_per_page
  	              (will_paginate(
  									record_set, :container => false, 
  									:previous_label => t('ponteggio.pagination.previous'), 
  									:next_label => t('ponteggio.pagination.next')) || '') + 
  								'&nbsp;[' + 
  								t('ponteggio.pagination.items_per_page', :n => @items_per_page) + '; ' + 
  								content_tag(:span, link_to(t('ponteggio.pagination.no_pagination'), :search => @search_params, :do_not_paginate => 1)) + ']'
  	            end
  					 	end + 
  					 	if in_csv_block
    						content_tag(:td, :class => 'csv_button_container') do
    						end
  						else
  						  ''
						  end
            end
          end
        end
      end
    end
    
    def index_item_links(record)
      link_to(image_tag('ponteggio/zoom.png'), polymorphic_url(record)) +
      link_to(image_tag('ponteggio/page_edit.png'), polymorphic_url(record, :action => :edit)) + 
      link_to(image_tag('ponteggio/cancel.png'), polymorphic_url(record), :method => :delete)
    end
    
    def index_links_box(model_class)
      link_to(t('ponteggio.links.new'), polymorphic_url(model_class.new, :action => :new))
    end

    # header for the index table -- with sortable controls
  	# columns is a list of column hashes
    def index_table_header(model_class, column_set)
      content_tag(:thead) do
        content_tag(:tr) do
          column_set.map do |column|
  					# sortable column
            if column[:sortable] && Ponteggio::USE_SEARCHLOGIC
              content_tag(
                :th,
                order(
                  @search,
                  :by => column[:key].to_s,
                  :as => column[:name] 
                )
              ) 
  					# this isn't a sortable column
            else
              content_tag(:th, column[:name])
            end                           
  				# add column for buttons in the index list
          end * "\n" + tag(:th)
        end
      end
    end  
    
  end
end