module ActiveModelStruct
  class CollectionSerializer
    attr_accessor :collection, :instance_options, :data
    def initialize(collection, options)
      @collection = collection
      @instance_options = options
    end

    def as_json
      collect_data.collect(&:as_json)
    end

    def to_json
      Oj.dump(collect_data.collect(&:as_json), mode: :compat)
    end

    def serializer_class
      self.class
    end

    private

    def collect_data
      if collection.respond_to?(:to_ary) || collection.respond_to?(:to_all)
        self.data ||= collection.collect{ |resource|
          Resolver.new(resource, instance_options).struct
        }
      else
        []
      end
    end
  end
end
