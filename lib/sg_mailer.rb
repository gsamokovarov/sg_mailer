require 'sg/mail'
require 'sg/mail_builder'
require 'sg/response_error'
require 'sg/job'
require 'sg/message_delivery'
require 'sg/transactional_mailer'

module SGMailer
  extend self

  attr_accessor :instance

  def send(mail)
    response = instance.client.mail._('send').post(request_body: mail.as_json)
    raise ResponseError, response if response.status_code.to_i > 299
    response
  end
end
