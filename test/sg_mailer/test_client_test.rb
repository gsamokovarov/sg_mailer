require 'test_helper'

module SGMailer
  class TestClientTest < Minitest::Test
    def test_empty_mail_request_queue
      test_client = TestClient.new

      assert_equal [], test_client.mail_requests
    end

    def test_mail_request_queue
      test_client = TestClient.new

      template_id = '00000000-0000-0000-0000-000000000000'
      mail = MailBuilder.build(from: 'gsamokovarov+from@gmail.com',
                               to: 'gsamokovarov+to@gmail.com',
                               template_id: template_id)

      test_client.send(mail)

      assert_equal test_client.mail_requests.map { |m| JSON.parse(m) },
        [
          'from' => { 'email' => 'gsamokovarov+from@gmail.com' },
          'personalizations' => [
            'to' => ['email' => "gsamokovarov+to@gmail.com"],
            'substitutions' => {}
          ],
          'content' => [
            'type' => 'text/html',
            'value' => '<html><body></body></html>'
          ],
          'template_id' => '00000000-0000-0000-0000-000000000000'
        ]
    end
  end
end
