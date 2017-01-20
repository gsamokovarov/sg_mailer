module SGMailer
  class TestClient
    attr_accessor :mail_requests

    def send(mail)
      mail_requests << mail.to_json
    end
  end
end
