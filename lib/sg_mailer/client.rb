require 'net/http'

module SGMailer
  class Client
    def initialize(api_key:, api_url: nil)
      @api_key = api_key
      @api_url ||= 'https://api.sendgrid.com/v3/mail/send'
      @api_uri = URI(@api_url)
    end

    def send(mail)
      Net::HTTP.start(*http_options) do |http|
        http.request(request(mail))
      end
    end

    private

    def http_options
      [@api_uri.host, @api_uri.port, https: @api_uri.scheme == 'https']
    end

    def request(body)
      Net::HTTP::Post.new(@api_uri, request_headers).tap do |req|
        req.body = body
      end
    end

    def request_headers
      {
        'Authorization' => "Bearer #{@api_key}",
        'Content-Type' => 'application/json'
      }
    end
  end
end
