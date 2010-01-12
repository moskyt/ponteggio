module Ponteggio
  module ValueHelper
    def value_for(object, column)
      case column[:kind]
      when :wysiwyg
        object.send(column[:key]).to_s
      when :textile
        textilize object.send(column[:key]).to_s
      when :object
        target = object.send(column[:key])
        link_to(target, target)
      when :objects
        targets = object.send(column[:key])
        separator = (column[:list] == :long) ? '<br />' : ', '
        targets.map{|target| link_to(target, target)} * separator
      else
        h(object.send(column[:key]).to_s)
      end
    end
    
    def truncated_value_for(object, column)
      base_value = case column[:kind]
      when :object, :objects
        # this is a bit crazy way to do that
        return value_for(object, column)
      when :textile
        h(object.send(column[:key]).to_s)
      else
        value_for(object, column)
      end
      truncate_html(base_value)
    end
    
    require 'rexml/parsers/pullparser'

    def truncate_html(str, len = 30)
      p = REXML::Parsers::PullParser.new(str)
      tags = []
      new_len = len
      results = ''
      while p.has_next? && new_len > 0
        p_e = p.pull
        case p_e.event_type
        when :start_element
          tags.push p_e[0]
          results << "<#{tags.last} #{attrs_to_s(p_e[1])}>"
        when :end_element
          results << "</#{tags.pop}>"
        when :text
          results << p_e[0].first(new_len)
          new_len -= p_e[0].length
        else
          results << "<!-- #{p_e.inspect} -->"
        end
      end
      tags.reverse.each do |tag|
        results << "</#{tag}>"
      end
      (results == str) ? results : "#{results} ..."
    end

    def attrs_to_s(attrs)
      if attrs.empty?
        ''
      else
        attrs.to_a.map { |attr| %{#{attr[0]}="#{attr[1]}"} }.join(' ')
      end
    end
          
  end
end