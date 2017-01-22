require 'sg_mailer/configuration_error'
require 'sg_mailer/response_error'
require 'sg_mailer/mail_builder'
require 'sg_mailer/client'
require 'sg_mailer/test_client'
require 'sg_mailer/base'

module SGMailer extend self
  attr_accessor :client
  attr_accessor :delivery_processor

  def configure(delivery_processor: default_delivery_processor,
                test_client: false, **client_options)
    self.client = test_client ? TestClient.new : Client.new(**options)
    self.delivery_processor = delivery_processor
  end

  def send(mail)
    raise ConfigurationError if client.nil?

    client.send(mail)
  end

  private

  def default_delivery_processor
    if defined?(::ActiveJob)
      require 'sg_mailer/delayed_delivery_processor'
      DelayedDeliveryProcessor
    else
      require 'sg_mailer/immediate_delivery_processor'
      ImmediateDeliveryProcessor
    end
  end
end
