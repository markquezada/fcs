require 'socket'
require 'fcs/config'
require 'fcs/response'
require 'fcs/request'
require 'fcs/string_request'
require 'fcs/hash_request'
require 'fcs/sendmsg_request'

module FCS
  class Client
    attr_accessor *Config::VALID_OPTIONS_KEYS

    # Initialize a new Client object
    def initialize(attrs={})
      attrs = FCS.options.merge(attrs)
      Config::VALID_OPTIONS_KEYS.each do |key|
        instance_variable_set("@#{key}".to_sym, attrs[key])
      end

      connect if @auto_connect
    end

    def connect
      unless @socket
        @socket = TCPSocket.open(@remote_host, @remote_port, @local_host, @local_port)
        Response.new(@socket).parse_response
      end
      @socket
    end

    # Delgate api call to Request
    def method_missing(method, *args, &block)
      klass = class_for_api_command(method)

      return klass.new(@socket).send(method, *args, &block) if klass
      super(method, *args, &block)
    end

    private

    def class_for_api_command(method)
      if method == :sendmsg
        SendmsgRequest
      elsif Request::VALID_HASH_COMMANDS.include?(method)
        HashRequest
      elsif Request::VALID_STRING_COMMANDS.include?(method)
        StringRequest
      else
        nil
      end
    end
  end
end
