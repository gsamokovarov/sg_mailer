module SGMailer
  class Mail < SendGrid::Mail
    alias as_json to_json

    def [](value)
      as_json[value]
    end
  end
end
