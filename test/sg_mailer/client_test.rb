require 'test_helper'

module SGMailer
  class ClientTest < Minitest::Test
    def setup
      SGMailer.configure(api_key: ENV['SG_API_KEY'])
    end

    def test_sending_a_mail_through_the_client
      template_id = 'e0d26988-d1d7-41ad-b1eb-4c4b37125893'
      mail = MailBuilder.build(from: 'gsamokovarov+from@gmail.com',
                               to: 'gsamokovarov+to@gmail.com',
                               template_id: template_id)

      SGMailer.send(mail)
    end

    def test_sending_a_mail_can_error_out
      template_id = '00000000-0000-0000-0000-000000000000'
      mail = MailBuilder.build(from: 'gsamokovarov+from@gmail.com',
                               to: 'gsamokovarov+to@gmail.com',
                               template_id: template_id)

      assert_raises SGMailer::ResponseError do
        SGMailer.send(mail)
      end
    end

    def test_api_url_can_be_changed
      client = Client.new(api_key: ENV['SG_API_KEY'],
                          api_url: 'https://example.com')

      assert_equal 'https://example.com', client.api_url
    end
  end
end
