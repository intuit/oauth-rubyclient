module IntuitOAuth
  class OAuth2ClientException < StandardError
    attr_reader :status_code, :body, :headers, :intuit_tid, :timestamp

    def initialize(response)
      @status_code = response.code
      @body = response.body
      @headers = response.headers
      @intuit_tid = response.headers['intuit_tid']
      @timestamp = response.headers['date']
      super("HTTP status #{@status_code}, error message: #{@body}, intuit_tid: #{@intuit_tid} on #{@timestamp}")
    end
  end
end
