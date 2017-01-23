require 'test_helper'
require 'sg_mailer/immediate_delivery_processor'

module SGMailer
  class ImmediateDeliveryProcessorTest < Minitest::Test
    def setup
      SGMailer.configure(api_key: ENV['SG_API_KEY'])
    end

    def test_no_delayed_delivery
      template_id = 'e0d26988-d1d7-41ad-b1eb-4c4b37125893'
      mail = MailBuilder.build(from: 'gsamokovarov+from@gmail.com',
                               to: 'gsamokovarov+to@gmail.com',
                               template_id: template_id)

      delivery_processor = ImmediateDeliveryProcessor.new(mail)
      delivery_processor.deliver_now
    end

    def test_no_delayed_delivery_even_on_deliver_later
      template_id = 'e0d26988-d1d7-41ad-b1eb-4c4b37125893'
      mail = MailBuilder.build(from: 'gsamokovarov+from@gmail.com',
                               to: 'gsamokovarov+to@gmail.com',
                               template_id: template_id)

      delivery_processor = ImmediateDeliveryProcessor.new(mail)
      delivery_processor.deliver_later
    end
  end
end
