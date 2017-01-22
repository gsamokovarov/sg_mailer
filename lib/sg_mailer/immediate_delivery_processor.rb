module SGMailer
  class ImmediateDeliveryProcessor
    def initialize(mail)
      @mail = mail
    end

    def deliver_now(**)
      return if early_return?

      SGMailer.send(@mail)
    end

    def deliver_later(**)
      return if early_return?

      SGMailer.send(@mail)
    end

    private

    def early_return?
      @mail.nil? || @mail.empty?
    end
  end
end
