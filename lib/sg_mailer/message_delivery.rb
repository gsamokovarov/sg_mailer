require 'delegate'

module SGMailer
  if defined?(ActiveJob)
    class Job < ActiveJob::Base
      def perform(mail)
        SGMailer.send(mail)
      end
    end

    class MessageDelivery < SimpleDelegator
      def deliver_now(**options)
        Job.set(options).perform_now(as_json) if as_json
      end

      def deliver_later(**options)
        Job.set(options).perform_later(as_json) if as_json
      end
    end
  else
    class MessageDelivery < SimpleDelegator
      def deliver_now(**options)
        SGMailer.send(as_json) if as_json
      end

      def deliver_later(**options)
        SGMailer.send(as_json_) if as_json
      end
    end
  end
end
