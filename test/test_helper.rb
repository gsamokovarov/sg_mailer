$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

begin
  require 'byebug'
rescue LoadError
  # It's fine.
end

require 'sg_mailer'

require 'minitest/autorun'
