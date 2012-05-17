require 'fcs/hash_request'

module FCS
  class SendmsgRequest < HashRequest
    # convenience method
    def execute(app, arg)
      self.call_command(:execute).execute_app_name(app).execute_app_arg(arg)
    end
  end
end
