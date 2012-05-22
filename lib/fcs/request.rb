require 'fcs/response'

module FCS
  class Request
    VALID_HASH_COMMANDS = [:sendmsg, :sendevent]
    VALID_STRING_COMMANDS = [:api, :bgapi, :event, :myevents, :divert_events,
                             :filter, :exit, :auth, :log, :nolog, :nixevent,
                             :noevents]
    VALID_COMMANDS = VALID_HASH_COMMANDS + VALID_STRING_COMMANDS

    def initialize(socket, response_class=Response)
      @socket = socket
      @response_class = response_class
    end

    def generate_command
      # defined in the subclasses
      raise NotImplementedError
    end

    def update_command(method, *args, &block)
      # defined in the subclasses
      raise NotImplementedError
    end

    def dispatch!
      dispatch_raw!("#{generate_command}\n\n")
    end

    def dispatch_raw!(command)
      @socket.write(command)
      @response_class.new(@socket).parse_and_respond
    end

    def method_missing(method, *args, &block)
      if @response_class.method_defined?(method)
        dispatch!.send(method, *args, &block)
      else
        update_command(method, *args, &block)
        self
      end
    end
  end
end
