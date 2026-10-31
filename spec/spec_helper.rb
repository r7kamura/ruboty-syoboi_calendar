require "ruboty/syoboi_calendar"
require "active_support/all"
require "rack"
require "webmock/rspec"

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
end
