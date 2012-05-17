require 'fcs/version'
require 'fcs/config'
require 'fcs/client'

module FCS
  extend Config
  class << self
    # Alias for FCS::Client.new
    #
    # @return [FCS::Client]
    def new(options={})
      FCS::Client.new(options)
    end

    # Delegate to FCS::Client
    def method_missing(method, *args, &block)
      return super unless new.respond_to?(method)
      new.send(method, *args, &block)
    end

    # Include FCS::Client methods in respond_to?
    def respond_to?(method, include_private=false)
      new.respond_to?(method, include_private) || super(method, include_private)
    end
  end
end
