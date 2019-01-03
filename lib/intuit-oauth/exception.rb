module IntuitOAuth
  class OAuth2ClientException < StandardError
    def initialize(response)
      @satus_code = response.code
      @body = response.body
      @headers = response.headers
      @intuit_tid = response.headers['intuit_tid']
      @timestamp = response.headers['date']
      super("HTTP status #{@satus_code}, error message: #{@body}, intuit_tid: #{@intuit_tid} on #{@timestamp}")
    end
  end
end