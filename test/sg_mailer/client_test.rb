require 'test_helper'

module SGMailer
  class ClientTest < Minitest::Test
    def setup
      SGMailer.configure(api_key: ENV['SG_API_KEY'])
    end

    def test_sending_a_mail_through_the_client
      template_id = 'e0d26988-d1d7-41ad-b1eb-4c4b37125893'
      mail = MailBuilder.new(from: 'gsamokovarov+from@gmail.com',
                             to: 'gsamokovarov+to@gmail.com',
                             template_id: template_id)

      SGMailer.send(mail.build)
    end
  end
end
