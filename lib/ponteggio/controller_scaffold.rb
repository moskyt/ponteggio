module Ponteggio
  module ControllerScaffold
            
    # six methods for maintaining the column lists
    def index_column_set(*symbols)
      @index_column_list = symbols
    end
  
    def get_index_column_list
      @index_column_list || @all_columns
    end
  
    def edit_column_set(*symbols)
      @edit_column_list = symbols
    end
  
    def get_edit_column_list
      @edit_column_list || @all_columns
    end
  
    def show_column_set(*symbols)
      @show_column_list = symbols
    end
  
    def get_show_column_list
      @show_column_list || @all_columns
    end
        
    # pagination
    def items_per_page(n = 20)
      @items_per_page = n
    end
      
    # extract the columns from the options heap,
    # add guessed type
    # and create an array of column-hashes
    # according to the list
    def map_column_set(model_class, column_list)
      column_list.map do |key|
        col = {:key => key}.merge((@columns || {})[key] || {})
        # get the reflection
        reflection = model_class.reflect_on_association(col[:key])
        unless reflection
          # database column
          if db_column = model_class.columns_hash[col[:key].to_s]
          # derived kind
            column_kind = col[:kind] || db_column.sql_type
            column_kind = column_kind.to_sym if column_kind
            # default_value
            col[:default] ||= db_column.extract_default(db_column.default)
          else
            # this is not a true column, is it?
            if Ponteggio::USE_GLOBALIZE2 && model_class.translates? && model_class.translated_attribute_names == col[:key]
              # this is a translated column
              col[:kind] = :translated
            end
          end
        end
        # get a human name
        col[:name] = model_class.human_attribute_name(col[:key])
        # overwrite the database-column-type in case of an association
        if reflection && !col[:kind]
          column_kind = case reflection.macro
          when :belongs_to, :has_one
            :object
          when :has_many, :has_and_belongs_to_many
            :objects
          end
        end
        # enumeration
        column_kind = :enum if model_class.is_enumeration?(col[:key])
        # write the final kind
        col[:kind] = column_kind
        col[:reflection] = reflection
        col
      end
    end
  
    # define a column
    def column(symbol, options)
      @columns ||= {}
      @columns[symbol] = options
    end
                 
  	# generator for scaffolding; used for all methods and for :create/:update on models without single table inheritance
    def ponteggio(model_class, *method_set) 
              
      @all_columns = []
      model_class.column_names.each do |key|
        @all_columns << key.to_sym
      end
      model_class.reflect_on_all_associations.each do |reflection|
        unless reflection.macro == :belongs_to
          unless (reflection.class_name =~ /::Translation/) && Ponteggio::USE_GLOBALIZE2
            @all_columns << reflection.name.to_sym
          end
        end
      end
      # do not display the id and the timestamps by default
      # FIXME : should use some_primary_key instead of id
      @all_columns -= [:id, :created_at, :updated_at]
              
      #pagination
      define_method :get_items_per_page do
        self.class.instance_variable_get(:"@items_per_page")
      end
              
      # common logic for Object.find(params[:id])
      # sets both @record and @{object}  
      define_method :find_record do
        @record = model_class.find(params[:id])
        instance_variable_set(:"@#{model_class.base_class.name.underscore}", @record)
      end    
      self.send(:private, :find_record)

      if method_set.include?(:index) or method_set.include?(:crud)
        define_method :index do                     

          # @default_order = @default_order.to_s.gsub("translations__", "translations_#{I18n.locale}_")
  				params[:search] ||= {}
          # params[:search][:order] ||= @default_order
  				@search_params = params[:search].dup
  				if Ponteggio::USE_SEARCHLOGIC
  		      @search = model_class.search(params[:search])
		      else
            @search = model_class.find(:all)
          end

  		    if get_items_per_page
		        @records = @search.paginate(:page => params[:page], :per_page => get_items_per_page)
		        @items_per_page = get_items_per_page
		      else
		        @records =  @search
		      end                                                                

          instance_variable_set :"@#{model_class.base_class.name.underscore.pluralize}", @records

  		    instance_variables.each {|iv| @template.instance_variable_set(iv, instance_variable_get(iv))}

          render :text => @template.index_page_for(
            model_class,
            @records,
            self.class.map_column_set(model_class, self.class.get_index_column_list)), :layout => true
        end
      end  

      if method_set.include?(:show) or method_set.include?(:crud)
        define_method :show do
          find_record
          render :text => @template.show_page_for(
            @record,
            self.class.map_column_set(model_class, self.class.get_show_column_list)), :layout => true
        end
      end
       
      if method_set.include?(:destroy) or method_set.include?(:crud)
        define_method :destroy do                     
          find_record
          @record.destroy
          redirect_to :action => :index
        end
      end
    
      if method_set.include?(:new) or method_set.include?(:crud)
        define_method :new do                     
          instance_variable_set(:"@#{model_class.base_class.name.underscore}", model_class.new)
          render :text => @template.new_page_for(
            model_class,
            instance_variable_get(:"@#{model_class.base_class.name.underscore}"),
            self.class.map_column_set(model_class, self.class.get_edit_column_list)), :layout => true
        end
      end
    
      if method_set.include?(:create) or method_set.include?(:crud)
        define_method :create do        
          cname = model_class.base_class.name.underscore             
          record = model_class.new(params[cname])
          if record.save
            redirect_to :action => :index
          else
            render :action => :new
          end
        end
      end

      if method_set.include?(:edit) or method_set.include?(:crud)
        define_method :edit do
          find_record
          render :text => @template.edit_page_for(
            @record,
            self.class.map_column_set(model_class, self.class.get_edit_column_list)), :layout => true
        end
      end
       
      if method_set.include?(:update) or method_set.include?(:crud)
        define_method :update do        
          find_record
          @record.attributes = params[model_class.base_class.name.underscore]
          if @record.save
            redirect_to :action => :index
          else
            render :action => :edit
          end
        end
      end
  
    end
        
  end
end