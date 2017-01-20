module SGMailer
  class TestClient
    attr_accessor :mail_requests

    def send(mail)
      mail_requests << mail
    end
  end
end
