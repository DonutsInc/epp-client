require File.expand_path('../command', __FILE__)

module EPP
  module Contact
    class Create < Command
      def initialize(id, options = {})
        @id = id

        @postal_info  = options.delete(:postal_info)
        @voice        = options.delete(:voice)
        @fax          = options.delete(:fax)
        @email        = options.delete(:email)
        @auth_info    = options.delete(:auth_info)
        @disclose     = options.delete(:disclose)

        postal_info_exception unless postal_info_type_is_valid?
      end

      def name
        'create'
      end

      def to_xml
        node = super
        node << contact_node('id', @id)
        @postal_info.each do |postal_info|
          node << postal_info_to_xml(postal_info)
        end
        node << contact_node('voice', @voice) if @voice
        node << contact_node('fax', @fax) if @fax
        node << contact_node('email', @email)
        node << auth_info_to_xml(@auth_info)
        node << disclose_to_xml(@disclose) if @disclose
        node
      end

      def postal_info_is_valid?
        @postal_info.size <= 2 && @postal_info.size >=0 && postal_info_type_is_valid?
      end

      def postal_info_type_is_valid?
        counter = { :loc => 0, :int => 0, :other => 0 }
        @postal_info.each do |postal_info|
          case postal_info[:type]
            when 'loc'
              counter[:loc] += 1
            when 'int'
              counter[:int] += 1
            else
              counter[:other] +=1
          end
        end
        counter[:loc] <= 1  && counter[:int] <= 1 && counter[:other] == 0
      end

      def postal_info_exception
        raise 'The provided postal_info is not valid'
      end
    end
  end
end
