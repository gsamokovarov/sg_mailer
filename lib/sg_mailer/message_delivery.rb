require 'delegate'

module SGMailer
  class MessageDelivery < SimpleDelegator
    if defined?(ActiveJob)
      require 'sg_mailer/job'

      def deliver_now(**options)
        Job.set(options).perform_now(as_json) if as_json
      end

      def deliver_later(**options)
        Job.set(options).perform_later(as_json) if as_json
      end
    else
      def deliver_now(**options)
        SGMailer.send(as_json) if as_json
      end

      def deliver_later(**options)
        SGMailer.send(as_json_) if as_json
      end
    end
  end
end
