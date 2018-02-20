# frozen_string_literal: true

def coverage_needed?
  ENV['COVERAGE'] || ENV['TRAVIS']
end

if coverage_needed?
  require 'coveralls'
  Coveralls.wear!('rails') do
    add_filter 'config'
    add_filter 'spec'
  end
end

require 'pathname'
app_root = Pathname.new(File.dirname(__FILE__)).parent
%w[
  app/models
].each do |path|
  $LOAD_PATH.unshift app_root + path
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
    mocks.allow_message_expectations_on_nil = false
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.filter_run_when_matching :focus
  config.disable_monkey_patching!
  config.example_status_persistence_file_path = "spec/examples.txt"
  if config.files_to_run.one?
    config.default_formatter = "doc"
  end

  # config.warnings = true
  # config.order = :random
  # Kernel.srand config.seed
end
