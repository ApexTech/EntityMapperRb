module EntityMapper
  class Model
    include JsonAttributesSerializer
    include AttributesFromHashInitializer
  end
end
