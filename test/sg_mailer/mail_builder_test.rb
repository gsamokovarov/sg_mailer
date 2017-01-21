require 'test_helper'

module SGMailer
  class MailBuilderTest < Minitest::Test
    def test_builds_an_email_without_substitutions
      template_id = 'e0d26988-d1d7-41ad-b1eb-4c4b37125893'
      mail = MailBuilder.new(from: 'me@foo.com',
                             to: 'ms@foo.com',
                             template_id: template_id)

      assert_equal mail.build,
        from: { email: "me@foo.com" },
        personalizations: [
          to: [email: "ms@foo.com"],
          substitutions: {}
        ],
        content: [
          type: "text/html",
          value: "<html><body></body></html>"
        ],
        template_id: "e0d26988-d1d7-41ad-b1eb-4c4b37125893"
    end

    def test_builds_an_email_with_substitutions
      template_id = 'e0d26988-d1d7-41ad-b1eb-4c4b37125893'
      mail = MailBuilder.new(from: 'me@foo.com',
                             to: 'ms@foo.com',
                             template_id: template_id,
                             substitutions: { '-FOO-' => 'BAR' })

      assert_equal mail.build,
        from: { email: "me@foo.com" },
        personalizations: [
          to: [email: "ms@foo.com"],
          substitutions: { '-FOO-' => 'BAR' }
        ],
        content: [
          type: "text/html",
          value: "<html><body></body></html>"
        ],
        template_id: "e0d26988-d1d7-41ad-b1eb-4c4b37125893"
    end

    def test_builds_an_email_with_multiple_recipients
      template_id = 'e0d26988-d1d7-41ad-b1eb-4c4b37125893'
      mail = MailBuilder.new(from: 'me@foo.com',
                             to: ['ms@foo.com', 'vs@foo.com'],
                             template_id: template_id)

      assert_equal mail.build,
        from: { email: "me@foo.com" },
        personalizations: [
          to: [{ email: "ms@foo.com" }, { email: "vs@foo.com" }],
          substitutions: {}
        ],
        content: [
          type: "text/html",
          value: "<html><body></body></html>"
        ],
        template_id: "e0d26988-d1d7-41ad-b1eb-4c4b37125893"
    end
  end
end
