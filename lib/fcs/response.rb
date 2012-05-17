module FCS
  class Response
    attr_reader :headers, :content

    def initialize(socket)
      @socket = socket
      @headers = ''
      @content = ''
      @content_length = 0
    end

    def parse_and_respond
      parse_response
      self
    end

    def parse_response
      capture_headers
      capture_content
      puts self.inspect
    end

    def ok?
      raw_reply.start_with?('+OK') or (@content_length and not error?)
    end

    def error?
      raw_reply.start_with?('-ERR')
    end

    def reply
      /^(?:\+OK|\-ERR)\s?(.*)/.match(raw_reply) ? Regexp.last_match(1) : raw_reply
    end

    private

    def raw_headers=(raw_headers)
      @headers = headers_2_hash(raw_headers.split("\n"))
      @headers.each {|k,v| v.chomp! if v.respond_to? :chomp!}
    end

    def raw_content=(raw_content)
      @content = raw_content.chomp!
    end

    def raw_reply
      @content_length > 0 ? @content : @headers[:reply_text]
    end

    def capture_headers
      self.raw_headers = @socket.readline("\n\n")
      @content_length = @headers[:content_length].to_i
    end

    def capture_content
      self.raw_content = @socket.read(@content_length) if @content_length > 0
    end

    # Stolen from eventmachine:
    # https://github.com/eventmachine/eventmachine/blob/master/lib/em/protocols/header_and_content.rb
    def headers_2_hash hdrs
      hash = {}
      hdrs.each do |h|
        if /\A([^\s:]+)\s*:\s*/ =~ h
          tail = $'.dup
          hash[ $1.downcase.gsub(/-/,"_").intern ] = tail
        end
      end
      hash
    end
  end
end
