require "active_model_struct/version"
require 'active_model_struct/resolver'
require 'active_model_struct/options_builder'
require 'active_model_struct/formatter'
require 'active_model_struct/serializer'
require 'active_model_struct/collection_serializer'

if defined?(Grape)
  require 'active_model_struct/grape/endpoint_struct_extension'
end
