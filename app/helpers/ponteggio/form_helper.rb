module Ponteggio
  module FormHelper
    
    def ponteggio_form_for(record, edit_column_set)
      capture do 
        form_for(record, :builder => Ponteggio::PonteggioFormBuilder) do |f|
          edit_column_set.each do |column|
            concat(f.edit_field(column[:key]))
          end
        end
      end
    end
    
  end
end