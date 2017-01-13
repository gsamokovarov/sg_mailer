module SGMailer
  class MailBuilder
    def initialize(**kw)
      @from = kw.fetch(:from)
      @to = Array(kw.fetch(:to)).uniq
      @substitutions = Hash(kw.fetch(:substitutions, {}))
      @template_id = kw[:template_id]
      @content = kw[:content]

      @mail = Mail.new
      @personalization = SendGrid::Personalization.new
    end

    def build
      add_subject
      add_templates
      add_contents
      add_to
      add_from
      add_substitutions

      finalize
      @mail
    end

    private

    def add_subject
      @mail.subject = @subject
    end

    def add_templates
      @mail.template_id = @template_id if @template_id
    end

    def add_contents
      @mail.contents = SendGrid::Content.new(type: 'text/html', value: "<html><body>#{@content}</body></html>")
      @mail.contents = SendGrid::Content.new(type: 'text/plain', value: @content) if @content
    end

    def add_to
      @to.each do |address|
        @personalization.to = new_email(address)
      end
    end

    def add_from
      @mail.from = new_email(@from)
    end

    def add_substitutions
      @substitutions.each do |key, value|
        @personalization.substitutions = SendGrid::Substitution.new(key: key, value: value.to_s)
      end
    end

    def finalize
      @mail.personalizations = @personalization
    end

    def new_email(email)
      SendGrid::Email.new(String === email ? { email: email } : email)
    end
  end
end
