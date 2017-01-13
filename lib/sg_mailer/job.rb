module SGMailer
  class Job < ActiveJob::Base
    def perform(mail)
      SG.send(mail)
    end
  end
end
