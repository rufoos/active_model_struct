module ActiveModelStruct
  module Formatter
    class << self
      def call(resource, env)
        options = ::ActiveModelStruct::OptionsBuilder.new(resource, env).options
        struct = fetch_struct(resource, options)

        if struct
          struct.to_json
        elsif defined?(Grape)
          Grape::Formatter::Json.call(resource, env)
        else
          Oj.dump(resource, mode: :compat)
        end
      end

      def fetch_struct(resource, options)
        ::ActiveModelStruct::Resolver.new(resource, options).struct
      end
    end
  end
end
