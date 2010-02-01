module Ponteggio
  module InternalActions

    # return numbers of items per page (used by SearchLogic/WillPaginate pagination)
    def get_items_per_page
      self.class.instance_variable_get(:"@items_per_page")
    end
    
    private  
            
    # common logic for Object.find(params[:id])
    # sets both @record and @{object}  
    def find_record
      @record = ponteggio_model_class.find(params[:id])
      instance_variable_set(:"@#{ponteggio_model_class.base_class.name.underscore}", @record)
    end    

  end
end
