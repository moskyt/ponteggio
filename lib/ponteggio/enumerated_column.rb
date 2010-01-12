module Ponteggio
  module EnumeratedColumn
    
    module ClassMethods
      def enum_string_for(column_key, value)
    		if value.blank?
    			'---'
    		else
        	I18n.t("activerecord.enumerations.#{self.base_class.name.underscore}.#{column_key}.#{value}", :default => value)
    		end
      end
      
      def enumeration(column_key, *args)
        @enums ||= {}
        @enums[column_key] = args
      end
      
      def is_enumeration?(column_key)
        !(@enums || {})[column_key].blank?
      end
      
      def get_enumeration_options(column_key)
        (@enums || {})[column_key]
      end
      
    	def enum_options_for(column_key)
        self.base_class.get_enumeration_options(column_key).map{|x|
          [enum_string_for(column_key, x), x]
        }
    	end
        
    end
    
    def self.included(klass)
      klass.extend ClassMethods
    end    
    
  end
end