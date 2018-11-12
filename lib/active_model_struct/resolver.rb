module ActiveModelStruct
  class Resolver
    def initialize(resource, options)
      self.resource = resource
      self.options = options
    end

    def struct
      if resource.respond_to?(:serializer_class)
        resource
      elsif resource.is_a?(Hash)
        resource.as_json
      else
        struct_class.new(resource, struct_options) if struct_class
      end
    end

    private

    attr_accessor :resource, :options

    def struct_class
      return @struct_class if defined?(@struct_class)
      @struct_class = resource_defined_class
      @struct_class ||= collection_class
      @struct_class ||= options[:serializer]
      @struct_class ||= options[:each_serializer]
      @struct_class ||= resource_struct_class
    end

    def resource_defined_class
      resource.serializer_class if resource.respond_to?(:serializer_class)
    end

    def collection_class
      if resource.respond_to?(:to_ary) || resource.respond_to?(:to_all)
        CollectionSerializer
      end
    end

    def struct_options
      options
    end

    def resource_struct_klass
      @resource_struct_klass ||= [
        resource_namespace,
        "#{resource_klass}Serializer"
      ].compact.join('::')
    end

    def resource_klass
      resource_class.name.demodulize
    end

    def resource_namespace
      klass = resource_class.name.deconstantize
      klass.empty? ? nil : klass
    end

    def resource_class
      if resource.respond_to?(:klass)
        resource.klass
      elsif resource.respond_to?(:to_ary) || resource.respond_to?(:all)
        resource.first.class
      else
        resource.class
      end
    end

    def resource_struct_class
      resource_struct_klass.safe_constantize
    end

  end
end