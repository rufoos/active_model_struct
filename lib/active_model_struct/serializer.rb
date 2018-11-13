module ActiveModelStruct
  class Serializer < OpenStruct
    attr_accessor :object, :data, :instance_options, :scope
    class_attribute :_attributes_data
    self._attributes_data = {}

    class << self
      def inherited(base)
        super
        base._attributes_data = _attributes_data.dup
      end

      def attributes(*attrs)
        attrs = attrs.first if attrs.first.class == Array
        attrs.each do |attr|
          attribute(attr)
        end
      end

      def attribute(attr, options = {})
        _attributes_data[attr] = options
      end
    end

    def initialize(object, options = {})
      @object = object
      @data = {}
      @instance_options = options
      @scope = OpenStruct.new(options[:scope] || {}) if options.has_key?(:scope)
      collect_data
      super(data)
    end

    def as_json
      stringify_keys!(data)
    end

    def to_json
      Oj.dump(stringify_keys!(data))
    end

    def exec_expr?(options)
      if options.has_key?(:if)
        instance_exec &options[:if]
      elsif options.has_key?(:unless)
        !instance_exec &options[:unless]
      else
        true
      end
    end

    def include_attr?(key)
      fields = @instance_options.fetch(:fields, [])
      if fields.present?
        fields.include?(key)
      else
        true
      end
    end

    def serializer_class
      self.class
    end

    private

    def collect_data
      return @data unless @data.empty?
      _attributes_data.each do |attr, options|
        key = options.fetch(:key, attr)
        if include_attr?(key) && exec_expr?(options)
          @data[key] = self.respond_to?(attr) ? self.try(attr) : object.try(attr)
        end
      end
    end

    def stringify_keys!(hash)
      hash.keys.each do |key|
        hash[key.to_s] = hash.delete(key)
      end
      hash
    end
  end
end
