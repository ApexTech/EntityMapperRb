module EntityMapper
  class EntityProperty
    TYPES_WITH_CONVERSION_METHODS = [:String, :Integer, :Float, :BigDecimal, :Array, :Hash]
    TYPES_WITH_PARSERS = [:Date, :DateTime, :Time]

    attr_reader :name, :key, :type, :args

    def initialize(name, type = nil, options = {})
      case name
      when Hash
        @name, @key = name.to_a.flatten
      else
        @name = name
        @key = options.fetch(:key, @name)
      end

      @type = type.to_sym if type
      @initialization_method_for_type = options[:method]
      @args = options.fetch(:args, [])
    end

    def initialization_method_for_type
      @initialization_method_for_type ||= begin
        case type
        when *TYPES_WITH_CONVERSION_METHODS
          nil
        when *TYPES_WITH_PARSERS
          :parse
        end
      end
    end
  end
end
