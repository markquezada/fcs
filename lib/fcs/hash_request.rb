require 'fcs/request'

module FCS
  class HashRequest < Request
    def initialize(socket)
      super(socket)
      @command_type = ''
      @command_value = ''
      @params = {}
    end

    def generate_command
      # TODO if app args is longer than 2048 octet limit, use alternate format
      cmd = "#{@command_type} #{@command_value}\n"
      cmd << @params.map do |k,v|
        "#{k.gsub(/_/, '-')}: #{v}"
      end.join("\n") if not @params.empty?
    end

    def update_command(method, *args, &block)
      arg_string = args.map(&:to_s).join(' ') || ''

      # assume the first call here is the command type and value
      if @command_type.empty?
        @command_type = method.to_s
        @command_value = arg_string
      else
        @params[method.to_s] = arg_string
      end
    end
  end
end
