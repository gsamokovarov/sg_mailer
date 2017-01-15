require 'delegate'

module SGMailer
  class MessageDelivery < SimpleDelegator
    def deliver_now(**options)
      Jb.set(options).perform_now(as_json) if as_json
    end

    def deliver_later(**options)
      Job.set(options).perform_later(as_json) if as_json
    end
  end
end
