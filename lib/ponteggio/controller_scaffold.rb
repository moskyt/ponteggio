module Ponteggio
module ControllerScaffold
            
  def define_index_gears(model_class)
    define_method :index_gears do
	    cname = :"@#{model_class.base_class.name.underscore.pluralize}"
      instance_variable_set cname, model_class.find(:all)
	    instance_variables.each do |iv|
		    @template.instance_variable_set(iv, instance_variable_get(iv))
	    end
    end
    self.send(:private, :index_gears)
  end
  
  def index_column_set(*symbols)
    @index_column_list = symbols
  end
  
  def get_index_column_list
    @index_column_list || []
  end
  
  def edit_column_set(*symbols)
    @edit_column_list = symbols
  end
  
  def get_edit_column_list
    @edit_column_list || []
  end
  
  def show_column_set(*symbols)
    @show_column_list = symbols
  end
  
  def get_show_column_list
    @show_column_list || []
  end
  
  def map_column_set(column_list)
    column_list.map do |key|
      {:key => key}.merge((@columns || {})[key] || {})
    end
  end
  
  def column(symbol, options)
    @columns ||= {}
    @columns[symbol] = options
  end
                 
	# generator for scaffolding; used for all methods and for :create/:update on models without single table inheritance
  def generic_scaffold(model_class, *method_set) 
        
    if method_set.include?(:index) or method_set.include?(:crud)
      define_index_gears(model_class)
      define_method :index do                     
        index_gears
        render :text => @template.index_page_for(
          model_class,
          instance_variable_get(:"@#{model_class.base_class.name.underscore.pluralize}"),
          self.class.map_column_set(self.class.get_index_column_list)), :layout => true
      end
    end  
       
    if method_set.include?(:new) or method_set.include?(:crud)
      define_method :new do                     
        instance_variable_set(:"@#{model_class.base_class.name.underscore}", model_class.new)
        render :text => @template.new_page_for(
          model_class,
          instance_variable_get(:"@#{model_class.base_class.name.underscore}"),
          self.class.map_column_set(self.class.get_edit_column_list)), :layout => true
      end
    end
  
  end
        
	# generator of scaffolding without providing the views; just setting the instance variables and this and that
  def generic_scaffold_without_view(model_class, *method_set)
          
    if method_set.include?(:index)
      define_method :index do
				@default_order = @default_order.to_s.gsub("translations__", "translations_#{I18n.locale}_")
				params[:search] ||= {}
				params[:search][:order] ||= @default_order
		    cname = :"@#{model_class.base_class.name.underscore.pluralize}"
				@search_params = params[:search].dup
		    if model_class
		      @search = model_class.search(params[:search])
		      if pg = items_per_page and !params[:do_not_paginate]
		        instance_variable_set cname, @search.paginate(:page => params[:page], :per_page => pg)
						@items_per_page = pg # if instance_variable_get(cname).size < @search.size
		      else
		        instance_variable_set cname, @search
		      end                                                                
		    end
      end
    end     
        
    if method_set.include?(:show)
      define_method :show do
        instance_variable_set "@#{model_class.base_class.name.underscore}", model_class.base_class.find(params[:id])
      end
    end

    if method_set.include?(:new)
      define_method :new do
        instance_variable_set "@#{model_class.base_class.name.underscore}", model_class.base_class.new
      end
    end

    if method_set.include?(:edit)
      define_method :edit do
        instance_variable_set "@#{model_class.base_class.name.underscore}", model_class.base_class.find(params[:id])
      end
    end     

  end

end
end