require 'fcs/request'

module FCS
  class StringRequest < Request
    def initialize(socket)
      super(socket)
      @commands = []
    end

    def generate_command
      @commands.join(' ')
    end

    def update_command(method, *args, &block)
      @commands << method.to_s
      @commands = @commands + args.map(&:to_s)
    end
  end
end
