require 'test_helper'

module SGMailer
  class BaseTest < Minitest::Test
    class SendGridMailer < SGMailer::Base
      template_id 'e0d26988-d1d7-41ad-b1eb-4c4b37125893'

      def welcome_mail
        mail from: 'me@foo.com', to: 'ms@foo.com'
      end
    end

    def setup
      SGMailer.configure(api_key: ENV['SG_API_KEY'])
    end

    def test_action_mailer_kind_of_interface
      mail = SendGridMailer.welcome_mail
      mail.deliver_later
    end
  end
end