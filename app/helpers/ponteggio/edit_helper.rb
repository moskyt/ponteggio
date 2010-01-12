module Ponteggio
  module EditHelper

    def edit_links_box(record)
      link_to(t('ponteggio.links.index'), polymorphic_url(record.class.new)) + ' | ' +
      link_to(image_tag('ponteggio/zoom.png'), polymorphic_url(record))
    end
    
  end
end