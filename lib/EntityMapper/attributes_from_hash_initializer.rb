require "forwardable"

module EntityMapper
  module AttributesFromHashInitializer
    extend Forwardable

    attr_reader :init_attrs

    def_delegators :init_attrs, :[], :fetch

    def NullConversionMethodProxyForInitializer(value)
      value
    end

    def initialize(attrs)
      @init_attrs = attrs.respond_to?(:with_indifferent_access) ? attrs.with_indifferent_access : attrs

      self.class.initializable_attributes_definitions.each do |(attribute, type)|
        instance_variable_set("@#{attribute}", build_from_type(type.to_s, init_attrs[attribute]))
      end
    end

    def build_from_type(type, value)
      conversion_method = if type.include?("::")
        type_parts = type.split("::")
        method_name = type_parts.last

        method_source = type_parts[0..-2].join("::")
        Module.const_get(method_source).method(method_name)
      else
        method(type.to_s)
      end

      conversion_method.call(value)
    end

    module ClassMethods
      def initializable_attributes_list
        initializable_attributes_definitions.keys
      end

      def initializable_attributes_definitions
        @initializable_attributes_definitions ||= @initializable_attributes_definitions || (superclass.respond_to?(:initializable_attributes_definitions) ? superclass.initializable_attributes_definitions.dup : {})
      end

      def initializable_attributes(*args)
        args.each { |arg| initializable_attribute(arg) }
      end

      def initializable_attribute(arg, type = :NullConversionMethodProxyForInitializer)
        initializable_attributes_definitions[arg] = type

        attr_reader arg
      end
    end

    def self.included(base)
      base.extend ClassMethods
    end
  end
end
