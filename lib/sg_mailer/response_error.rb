module SGMailer
  class ResponseError < StandardError
    def initialize(response)
      @response = response

      super(build_message)
    end

    def status
      @response.status
    end

    private

    def build_message
      "Error from SendGrid:\n#{@response.body}"
    end
  end
end
