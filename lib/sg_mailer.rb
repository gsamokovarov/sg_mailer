require 'sg_mailer/configuration_error'
require 'sg_mailer/response_error'
require 'sg_mailer/mail_builder'
require 'sg_mailer/client'
require 'sg_mailer/message_delivery'
require 'sg_mailer/base'

module SGMailer extend self
  def configure(**options)
    self.client = Client.new(**options)
  end

  def send(mail)
    raise ConfigurationError if client.nil?

    client.send(mail)
  end

  private

  attr_accessor :client
end
