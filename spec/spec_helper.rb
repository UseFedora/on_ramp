require "bundler/setup"
require_relative "../lib/on_ramp"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:suite) do
    OnRamp.configure do |config|
      config.ab_experiments = 'spec/example_segment_configuration.yaml'
    end
  end
end
