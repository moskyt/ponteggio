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
      
      # prepare the list of all columns, which is used by default for all the *_column_set, if they
      # are not supplied by the user        
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
      
      # define a method providing the model class
      define_method :ponteggio_model_class do
        model_class
      end
              
      include Ponteggio::InternalActions

      %w{index show destroy new create edit update}.each do |method|
        send(:"define_#{method}") if method_set.include?(method.to_sym) or method_set.include?(:crud)
      end
  
    end
        
  end
end