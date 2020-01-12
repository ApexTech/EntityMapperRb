require "forwardable"

module EntityMapper
  module AttributesFromHashInitializer
    extend Forwardable

    attr_reader :init_attrs

    def_delegators :init_attrs, :[], :fetch

    def initialize(attrs)
      @init_attrs = attrs.respond_to?(:with_indifferent_access) ? attrs.with_indifferent_access : attrs

      self.class.initializable_attributes_definitions.each do |(attribute, property_metadata)|
        instance_variable_set("@#{attribute}", PropertyInitializerFromValue.call(property_metadata, init_attrs[property_metadata.key]))
      end
    end

    module ClassMethods
      def initializable_attributes_list
        initializable_attributes_definitions.keys
      end

      def initializable_attributes_definitions
        @initializable_attributes_definitions ||= @initializable_attributes_definitions || (superclass.respond_to?(:initializable_attributes_definitions) ? superclass.initializable_attributes_definitions.dup : {})
      end

      def initializable_attributes(*args)
        args.flatten.each { |arg| initializable_attribute(arg) }
      end

      def initializable_attribute(arg, type = nil, options = {})
        property = EntityProperty.new(arg, type, options)
        initializable_attributes_definitions[property.name] = property

        attr_reader property.name
      end
    end

    def self.included(base)
      base.extend ClassMethods
    end
  end
end
