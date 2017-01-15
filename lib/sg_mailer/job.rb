module SGMailer
  class Job < ActiveJob::Base
    def perform(mail)
      SGMailer.send(mail)
    end
  end
end
