module Ponteggio
  module ValueHelper
    def value_for(object, column)
      object.send(column[:key]).to_s
    end
  end
end