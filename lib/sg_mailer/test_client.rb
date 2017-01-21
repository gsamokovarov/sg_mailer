module SGMailer
  class TestClient
    attr_accessor :mail_requests

    def initialize
      @mail_requests = []
    end

    def send(mail)
      mail_requests << mail.to_json
    end
  end
end
