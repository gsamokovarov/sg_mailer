module SGMailer
  class DelayedDeliveryProcessor
    class Job < ActiveJob::Base
      def perform(mail)
        SGMailer.send(mail)
      end
    end

    def initialize(mail)
      @mail = mail
    end

    def deliver_now(**options)
      return if early_return?

      Job.set(options).perform_now(@mail)
    end

    def deliver_later(**options)
      return if early_return?

      Job.set(options).perform_later(@mail)
    end

    private

    def early_return?
      @mail.nil? || @mail.empty?
    end
  end
end
