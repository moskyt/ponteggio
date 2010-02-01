module Ponteggio
  module ControllerActionDefiners
          
    def define_index
      define_method :index do                     

        # @default_order = @default_order.to_s.gsub("translations__", "translations_#{I18n.locale}_")
				params[:search] ||= {}
        # params[:search][:order] ||= @default_order
				@search_params = params[:search].dup
				if Ponteggio::USE_SEARCHLOGIC
		      @search = ponteggio_model_class.search(params[:search])
	      else
          @search = ponteggio_model_class.find(:all)
        end

		    if get_items_per_page
	        @records = @search.paginate(:page => params[:page], :per_page => get_items_per_page)
	        @items_per_page = get_items_per_page
	      else
	        @records =  @search
	      end                                                                

        instance_variable_set :"@#{ponteggio_model_class.base_class.name.underscore.pluralize}", @records

		    instance_variables.each {|iv| @template.instance_variable_set(iv, instance_variable_get(iv))}

        render :text => @template.index_page_for(
          ponteggio_model_class,
          @records,
          self.class.map_column_set(ponteggio_model_class, self.class.get_index_column_list)), :layout => true
      end
    end  

    def define_show
      define_method :show do
        find_record
        render :text => @template.show_page_for(
          @record,
          self.class.map_column_set(ponteggio_model_class, self.class.get_show_column_list)), :layout => true
      end
    end
     
    def define_destroy
      define_method :destroy do                     
        find_record
        @record.destroy
        redirect_to :action => :index
      end
    end
  
    def define_new
      define_method :new do                     
        instance_variable_set(:"@#{ponteggio_model_class.base_class.name.underscore}", ponteggio_model_class.new)
        render :text => @template.new_page_for(
          ponteggio_model_class,
          instance_variable_get(:"@#{ponteggio_model_class.base_class.name.underscore}"),
          self.class.map_column_set(ponteggio_model_class, self.class.get_edit_column_list)), :layout => true
      end
    end
  
    def define_create
      define_method :create do        
        cname = ponteggio_model_class.base_class.name.underscore             
        record = ponteggio_model_class.new(params[cname])
        if record.save
          redirect_to :action => :index
        else
          render :action => :new
        end
      end
    end

    def define_edit
      define_method :edit do
        find_record
        render :text => @template.edit_page_for(
          @record,
          self.class.map_column_set(ponteggio_model_class, self.class.get_edit_column_list)), :layout => true
      end
    end
     
    def define_update
      define_method :update do        
        find_record
        @record.attributes = params[ponteggio_model_class.base_class.name.underscore]
        if @record.save
          redirect_to :action => :index
        else
          render :action => :edit
        end
      end
    end

  end
end