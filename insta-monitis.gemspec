# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'insta-monitis/ver/version'

Gem::Specification.new do |spec|
  spec.name          = "insta-monitis"
  spec.version       = InstaMonitis::VERSION
  spec.authors       = ["Dan Pramann"]
  spec.email         = ["dpramann@lakana.com"]

  spec.summary       = "CLI interface for Monitis API" 
  spec.description   = "A CLI which allows you to create and list HTTP and Full Page Load tests in Monitis"
  spec.homepage      = "https://github.com/praymann/insta-monitis"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  # if spec.respond_to?(:metadata)
  # spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  # else
  #  raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  # end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'thor'

end
