lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "ellen/syoboi_calendar/version"

Gem::Specification.new do |spec|
  spec.name          = "ellen-syoboi_calendar"
  spec.version       = Ellen::SyoboiCalendar::VERSION
  spec.authors       = ["Ryo Nakamura"]
  spec.email         = ["r7kamura@gmail.com"]
  spec.summary       = "Ask today's Japanese anime line-up from cal.syoboi.jp."
  spec.homepage      = "https://github.com/r7kamura/ellen-syoboi_calendar"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "ellen", ">= 0.2.0"
  spec.add_dependency "syoboi_calendar", "0.2.1"
  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "2.14.1"
end
