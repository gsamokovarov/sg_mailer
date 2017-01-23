require 'test_helper'

module SGMailer
  class BaseTest < Minitest::Test
    class SendGridMailer < SGMailer::Base
      default from: { name: 'Genadi', email: 'gsamokovarov+from@gmail.com' }

      template_id 'e0d26988-d1d7-41ad-b1eb-4c4b37125893'
      def welcome_mail_with_default_optins
        mail to: 'gsamokovarov+to@gmail.com'
      end

      template_id 'e0d26988-d1d7-41ad-b1eb-4c4b37125893'
      def welcome_mail_with_overriden_deep_defaults
        mail from: { name: 'Not Genadi' },
             to: 'gsamokovarov+to@gmail.com'
      end

      template_id 'e0d26988-d1d7-41ad-b1eb-4c4b37125893'
      def welcome_mail_with_normalized_substitutions
        @foo = 42
        @bar = 'string'

        mail to: 'gsamokovarov+to@gmail.com'
      end

      private

      def normalize_options(_options)
        automatic_substitutions = Hash[instance_variables.map do |ivar|
          ["#{ivar.to_s.gsub(/@|_/, '').upcase}", instance_variable_get(ivar)]
        end]

        deep_merge(super, substitutions: automatic_substitutions)
      end
    end

    def setup
      SGMailer.configure(api_key: ENV['SG_API_KEY'])
    end

    def test_action_mailer_like_interface
      mail = SendGridMailer.welcome_mail_with_default_optins

      mail.deliver_now
      mail.deliver_later
    end

    def test_default_options_are_respected
      mail = SendGridMailer.new.welcome_mail_with_default_optins

      assert_equal 'gsamokovarov+from@gmail.com', mail[:from][:email]
    end

    def test_overriden_default_options
      mail = SendGridMailer.new.welcome_mail_with_overriden_deep_defaults

      assert_equal 'Not Genadi', mail[:from][:name]
      assert_equal 'gsamokovarov+from@gmail.com', mail[:from][:email]
    end

    def test_annotated_template_id
      template_id = 'e0d26988-d1d7-41ad-b1eb-4c4b37125893'
      mail = SendGridMailer.new.welcome_mail_with_default_optins

      assert_equal template_id, mail[:template_id]
    end

    def test_normalized_options_processing
      mail = SendGridMailer.new.welcome_mail_with_normalized_substitutions

      assert_equal mail[:personalizations][0][:substitutions],
        'FOO' => '42',
        'BAR' => 'string'
    end
  end
end
