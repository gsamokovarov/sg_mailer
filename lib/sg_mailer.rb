require 'sg_mailer/configuration_error'
require 'sg_mailer/response_error'
require 'sg_mailer/mail_builder'
require 'sg_mailer/client'
require 'sg_mailer/test_client'
require 'sg_mailer/message_delivery'
require 'sg_mailer/base'

module SGMailer extend self
  attr_accessor :client

  def configure(test_client: false, **options)
    self.client =
      if test_client
        TestClient.new
      else
        Client.new(**options)
      end
  end

  def send(mail)
    raise ConfigurationError if client.nil?

    client.send(mail)
  end
end
