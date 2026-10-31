lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "ruboty/syoboi_calendar/version"

Gem::Specification.new do |spec|
  spec.name          = "ruboty-syoboi_calendar"
  spec.version       = Ruboty::SyoboiCalendar::VERSION
  spec.authors       = ["Ryo Nakamura"]
  spec.email         = ["r7kamura@gmail.com"]
  spec.summary       = "Ask today's Japanese anime line-up from cal.syoboi.jp."
  spec.homepage      = "https://github.com/r7kamura/ruboty-syoboi_calendar"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/releases"
  spec.metadata["rubygems_mfa_required"] = "true"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 3.3"

  spec.add_dependency "activesupport"
  spec.add_dependency "ruboty"
  spec.add_dependency "syoboi_calendar", "0.3.1"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rack"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "webmock"
end
