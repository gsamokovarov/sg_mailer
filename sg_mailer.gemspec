# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sg_mailer/version'

Gem::Specification.new do |spec|
  spec.name          = 'sg_mailer'
  spec.version       = SGMailer::VERSION
  spec.authors       = ['Genadi Samokovarov']
  spec.email         = ['gsamokovarov@gmail.com']

  spec.summary       = 'Action Mailer-like framework for SendGrid transactional mails'
  spec.description   = 'Action Mailer-like framework for SendGrid transactional mails'
  spec.homepage      = 'https://github.com/gsamokovarov/sg_mailer'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
