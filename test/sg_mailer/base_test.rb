require 'test_helper'

module SGMailer
  class BaseTest < Minitest::Test
    class SendGridMailer < SGMailer::Base
      template_id 'e0d26988-d1d7-41ad-b1eb-4c4b37125893'
      def welcome_mail
        mail from: 'gsamokovarov+from@gmail.com',
             to: 'gsamokovarov+ti@gmail.com'
      end
    end

    def setup
      SGMailer.configure(api_key: ENV['SG_API_KEY'])
    end

    def test_action_mailer_kind_of_interface
      SendGridMailer.welcome_mail.deliver_now
      SendGridMailer.welcome_mail.deliver_later
    end
  end
end
