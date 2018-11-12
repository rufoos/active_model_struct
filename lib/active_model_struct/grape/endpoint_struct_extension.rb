module Grape
  module EndpointStructExtension
    def render(resources, extra_options = {})
      options = extra_options.symbolize_keys
      adapter_options = options.slice(
        :fields, :serializer, :each_serializer
      )
      if adapter_options[:fields].present?
        adapter_options[:fields] = adapter_options[:fields].map(&:to_sym)
      end
      env['ams_adapter'] = adapter_options
      resources
    end

    def route_options
      if respond_to?(:inheritable_setting)
        inheritable_setting.route
      else
        options[:route_options]
      end
    end
  end

  Endpoint.send(:include, EndpointStructExtension)
end
