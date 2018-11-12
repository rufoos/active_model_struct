module ActiveModelStruct
  class OptionsBuilder
    def initialize(resource, env)
      self.resource = resource
      self.env = env
    end

    def options
      @options ||= (
        options = endpoint_options
        options.merge!(scope: scope_options)
        options.merge!(adapter_options)
        options
      )
    end

    private

    attr_accessor :resource, :env

    def endpoint_options
      [
        endpoint.options.fetch(:route_options)
      ].reduce(:merge)
    end

    def scope_options
      if env['current_user']
        { current_user: env['current_user'] }
      end
    end

    def endpoint
      @endpoint ||= env['api.endpoint']
    end

    def adapter_options
      env['ams_adapter'] || {}
    end
  end
end
