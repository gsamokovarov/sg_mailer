require 'net/http'

module SGMailer
  class Client
    attr_reader :api_key

    def initialize(api_key:, api_url: nil)
      @api_key = api_key
      @api_url ||= 'https://api.sendgrid.com/v3/mail/send'
      @api_uri = URI(@api_url)
    end

    def send(mail)
      response =
        Net::HTTP.start(*http_options) do |http|
          http.request(request(mail.to_json))
        end

      raise ResponseError.new(response) if response.code.to_i > 299

      response
    end

    private

    def http_options
      [@api_uri.host, @api_uri.port, https: @api_uri.scheme == 'https']
    end

    def request(body)
      request = Net::HTTP::Post.new(@api_uri, request_headers)
      request.body = body
      request
    end

    def request_headers
      { 'Authorization' => "Bearer #{@api_key}",
        'Content-Type' => 'application/json' }
    end
  end
end
