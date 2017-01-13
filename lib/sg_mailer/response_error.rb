module SGMailer
  class ResponseError < StandardError
    def initialize(response)
      @response = response

      super(extract_message)
    end

    def status_code
      @response.status_code
    end

    def body
      @body ||= Hash(JSON.parse(@response.body))
    end

    def headers
      # Cause somebody decided to inspect a hash and return the string
      # representation.
      @headers ||= JSON.parse(@response.headers.gsub('"=>"', '":'))
    end

    private

    def extract_message
      body.fetch('errors', []).reduce('') do |final, err|
        final << err['message'].to_s
      end
    end
  end
end
