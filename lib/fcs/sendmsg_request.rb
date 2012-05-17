require 'fcs/hash_request'

module FCS
  class SendmsgRequest < HashRequest
    # convenience method
    def execute(app, *args)
      self.call_command(:execute).execute_app_name(app).execute_app_arg(args.map(&:to_s).join(' '))
    end
  end
end
