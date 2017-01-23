module SGMailer
  class MailBuilder
    def self.build(*args)
      new(*args).build
    end

    def initialize(from:, to:, template_id:, substitutions: {})
      @from = normalize_email(from)
      @to = Array(to).map { |email| normalize_email(email) }
      @substitutions = normalize_substitutions(substitutions)
      @template_id = template_id
    end

    def build
      { from: normalize_email(@from),
        personalizations: [to: @to, substitutions: @substitutions],
        content: content_for_template,
        template_id: @template_id }
    end

    private

    def normalize_email(email)
      if email.is_a?(String)
        { email: email }
      else
        email
      end
    end

    def normalize_substitutions(substitutions)
      Hash[substitutions.map do |key, value|
        [key.to_s, value.to_s]
      end]
    end

    def content_for_template
      [type: "text/html", value: "<html><body></body></html>"]
    end
  end
end
