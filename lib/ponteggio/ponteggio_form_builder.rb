module Ponteggio
  class PonteggioFormBuilder < ActionView::Helpers::FormBuilder



  	# control from selecting a subset of a "record_set"
  	# using a dropdown and a list with 'remove' buttons
  	# dom_id identifies this selector uniquely
  	# base_name is the input name, to which [] will be appended
    def multiple_select_js(field_name, record_set, selected_set, dom_id)
      # container for the selected objects
  		# with the pre-selected set
      @template.content_tag(:div, :id => dom_id + '_container') do
  			selected_set.map do |record|
  			  @template.content_tag :span, :id => "#{dom_id}_record_#{record.id}" do
  	        %{<input type="hidden" name="#{field_name}[]" value="#{record.id}">
  	          #{@template.link_to_function 'remove', "Element.remove('#{dom_id}_record_#{record.id}');#{dom_id}_selected[#{record.id}] = false;"}
  	          #{record.to_s}<br />}
	        end
  			end * ''
  		end +
      # the dropdown for selecting objs
      @template.select_tag('', @template.options_for_select(record_set.map{|r| [r.to_s, r.id]}), :id => dom_id + '_select') +
      # JS for : mapping ids to captions; tracing what was already selected
      @template.javascript_tag( %Q{
        var #{dom_id}_map = {};
        var #{dom_id}_selected = {};
        #{record_set.map{|x| "#{dom_id}_map[#{x.id}] = '#{x.to_s}'; #{dom_id}_selected[#{x.id}] = #{selected_set.include?(x).to_s};"}}
      }) +
      # the ADD button
      @template.link_to_function('add', %Q{
        // selected value
        var id = $('#{dom_id}_select').value;
        // js for the REMOVE button
        var js = 'Element.remove(\\'#{dom_id}_record_'+id+'\\');#{dom_id}_selected[id] = false;';
        // html for the record row
        var html = '<span id="#{dom_id}_record_'+id+'">' + 
  								 '<a href="#" onclick="'+js+'">remove</a>' +
  								 #{dom_id}_map[id] +
                   '<input type="hidden" name="#{field_name}[]" value="' + id + '"><br /></span>';
        // paste only if it was not already selected
        if (!#{dom_id}_selected[id]) Element.insert('#{dom_id}_container', {bottom : html});
        #{dom_id}_selected[id] = true;
      })
    end

  	# control from selecting a subset of a "record_set"
  	# using a bunch of checkboxes
  	# dom_id identifies this selector uniquely
  	# base_name is the input name, to which [] will be appended
    def multiple_select_checkbox(field_name, record_set, selected_set, dom_id)
      @template.content_tag(:div, :id => dom_id) do           
        @template.hidden_field_tag("#{field_name}[]", "0") +
  			# render checkboxes for all records
        record_set.map do |record|
          @template.content_tag(:div, :class => 'multiple_select_checkbox_containter', :id => "#{dom_id}_record_#{record.id}") do
  					# tick those which are already selected
            @template.check_box_tag("#{field_name}[]", record.id, selected_set.include?(record)) +
  					# print the record name
            record.to_s
          end
        end * "\n" 
      end + @template.content_tag(:div, '', :style => 'clear:both')
    end

  	# habtm relation editor, allowing to filter possible selections with scope
  	# and allowing :checkbox or :dropdown look-n-feel
    def habtm_select(association, scope = :all, style = :checkbox)
  		object_model = object.class
  		reflection = object_model.reflect_on_association(association)
      record_set = reflection.class_name.to_s.classify.constantize.send(scope || :all)
      selected_set = object.send(association) || []
      dom_id = "multiple_select_#{object_model.name}_#{association}_#{object && object.id}"
      field_name = "#{object_model.name.underscore}[#{association.to_s.singularize}_ids]"
  		case (style || :checkbox)
      when :checkbox 
  			multiple_select_checkbox(field_name, record_set, selected_set, dom_id)
  		when :dropdown
  			multiple_select_js(field_name, record_set, selected_set, dom_id)
  		end
    end
    
    def edit_field(column, *args)
      # get the value or default
      value = object.send(column[:key]) || column[:default]
      object.send("#{column[:key]}=", value)
      case column[:kind]
      when :date  
        datetime_select(column[:key], {:discard_hour => true}, *args)
      when :time
        datetime_select(column[:key], {:discard_year => true, :discard_month => true, :discard_day => true}, *args)
      when :datetime
        datetime_select(column[:key], *args)
      when :text, :textile, :wysiwyg
        text_area(column[:key], *args)
      when :enum
        opts = args.last.is_a?(Hash) ? args.last : {} 
        select_opts = object.class.enum_options_for(column[:key])
        if opts.delete(:include_blank)
          select_opts = [['---', nil]] + select_opts
        end
        select column[:key], @template.options_for_select(select_opts, value), opts
      when :boolean
        check_box(column[:key], *args)
      when :objects
        habtm_select(column[:key], column[:scope], column[:style])
      when :object
        collection_select(
          column[:reflection].primary_key_name, 
          column[:reflection].class_name.classify.constantize.send(column[:scope] || :all),
          :id, :to_s, *args )
      else
        text_field(column[:key], *args)
      end
    end
    
    def edit_for(column, *args)
      @template.content_tag :p do
        label(column[:key], object.class.human_attribute_name(column[:key])) + '<br />' + edit_field(column, *args)
      end
    end
    
  end
end