module Ponteggio
  module InPlaceHelper
    
    def in_place_edit_for(object, column_name, *args)
      opts = args.extract_options!
      id = opts[:id] || dom_id(object)
      get_url = begin
        polymorphic_path(object, :format => :json, :attr => column_name) 
      rescue => e
        raise "Controller has to be specified for non-RESTful in-place-editor. #{e.backtrace}" unless opts[:controller]
        url_for(:controller => opts[:controller], :action => :show, :format => :json, :attr => column_name, :id => object.id)
      end
      set_url = ''
      out = content_tag(:span, "Loading value...", :id => "value_#{id}")
      out << remote_function(:update => "value_#{id}", :url => get_url)
      out << javascript_tag(%{new Ajax.InPlaceEditor('value_#{id}', '#{set_url}',
        { 
          onFormReady: function(obj,form) {
            var element = form.getInputs().first();
            alert(element);
          }
        });})
      out
    end
    
  end
end