module Ponteggio
  module ControllerActionDefiners
          
    def define_index(view_generator)
      define_method :index do                     

				params[:search] ||= {}
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
        
        render_index
      end
    end  

    def define_show(view_generator)
      define_method :show do
        find_record
        view_generator.render_show
      end
    end
     
    def define_destroy(view_generator)
      define_method :destroy do                     
        find_record
        @record.destroy
        redirect_to :action => :index
      end
    end
  
    def define_new(view_generator)
      define_method :new do                     
        instance_variable_set(:"@#{ponteggio_model_class.base_class.name.underscore}", ponteggio_model_class.new)
        view_generator.render_new
      end
    end
  
    def define_create(view_generator)
      define_method :create do        
        cname = ponteggio_model_class.base_class.name.underscore             
        record = ponteggio_model_class.new(params[cname])
        if record.save
          redirect_to :action => :index
        else
          view_generator.render_new
        end
      end
    end

    def define_edit(view_generator)
      define_method :edit do
        find_record
        view_generator.render_edit
      end
    end
     
    def define_update(view_generator)
      define_method :update do        
        find_record
        @record.attributes = params[ponteggio_model_class.base_class.name.underscore]
        if @record.save
          redirect_to :action => :index
        else
          view_generator.render_edit
        end
      end
    end

  end
end