module FCS
  module Config
    # Remote host used if none is set
    DEFAULT_REMOTE_HOST = 'http://127.0.0.1'

    # Remote port used if none is set
    DEFAULT_REMOTE_PORT = '8021'

    # Local host used if none is set
    DEFAULT_LOCAL_HOST = nil

    # Local port used if none is set
    DEFAULT_LOCAL_PORT = nil

    # Auto connect value used if none is set
    DEFAULT_AUTO_CONNECT = true

    # An array of valid keys in the options hash when configuring a {FCS::Client}
    VALID_OPTIONS_KEYS = [
      :remote_host,
      :remote_port,
      :local_host,
      :local_port,
      :auto_connect
    ]

    attr_accessor *VALID_OPTIONS_KEYS

    # When this module is extended, set all configuration options to their default value
    def self.extended(base)
      base.reset
    end

    # Convenience method to allow configuration options to be set in a block
    def configure
      yield self
      self
    end

    # Create a hash of options and their values
    def options
      options = {}
      VALID_OPTIONS_KEYS.each {|k| options[k] = send(k)}
      options
    end

    # Reset all configuration options to defaults
    def reset
      self.remote_host  = DEFAULT_REMOTE_HOST
      self.remote_port  = DEFAULT_REMOTE_PORT
      self.local_host   = DEFAULT_LOCAL_HOST
      self.local_port   = DEFAULT_LOCAL_PORT
      self.auto_connect = DEFAULT_AUTO_CONNECT
      self
    end
  end
end
