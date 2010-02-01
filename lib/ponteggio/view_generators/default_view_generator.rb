module Ponteggio
  module ViewGenerators
    module DefaultViewGenerator
      
      def render_index
        begin
          default_template
        rescue ActionView::MissingTemplate
          render :text => @template.index_page_for(
            ponteggio_model_class,
            @records,
            self.class.map_column_set(ponteggio_model_class, self.class.get_index_column_list)), :layout => true
        end
      end  

      def render_show
        begin
          default_template
        rescue ActionView::MissingTemplate
          render :text => @template.show_page_for(
            @record,
            self.class.map_column_set(ponteggio_model_class, self.class.get_show_column_list)), :layout => true
        end
      end

      def render_new
        begin
          default_template
        rescue ActionView::MissingTemplate
          render :text => @template.new_page_for(
            ponteggio_model_class,
            instance_variable_get(:"@#{ponteggio_model_class.base_class.name.underscore}"),
            self.class.map_column_set(ponteggio_model_class, self.class.get_edit_column_list)), :layout => true
        end
      end

      def render_edit
        begin
          default_template
        rescue ActionView::MissingTemplate
          render :text => @template.edit_page_for(
            @record,
            self.class.map_column_set(ponteggio_model_class, self.class.get_edit_column_list)), :layout => true
        end
      end
    end
  end
end
