module EntityMapper
  class PropertyInitializerFromValue
    PROXY_CONVERSION_METHOD_NAME = :NullConversionMethodProxyForInitializer

    class << self
      def NullConversionMethodProxyForInitializer(value)
        value
      end

      def call(property, value)
        return value unless property.type

        type = property.type.to_s

        if property.initialization_method_for_type
          Module.const_get(type).method(property.initialization_method_for_type).call(value, *property.args)
        else
          conversion_method = type.include?("::") ? conversion_method_from_inside_module(type) : method(type.to_s)
          conversion_method.call(value)
        end
      end

      def conversion_method_from_inside_module(type)
        type_parts = type.split("::")
        method_name = type_parts.last

        method_source = type_parts[0..-2].join("::")
        Module.const_get(method_source).method(method_name)
      end
    end
  end
end
