module Ponteggio
  class PonteggioFormBuilder < ActionView::Helpers::FormBuilder
    define_method :edit_field do |field, *args|
      text_field(field, *args)
    end
  end
end