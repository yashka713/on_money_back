ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
abort('The Rails environment is running in production mode!') if Rails.env.production?

require 'rspec/rails'
require 'byebug'
require 'database_cleaner'
require 'dotenv/load'
require 'factory_bot'
require 'faker'
require 'rspec/collection_matchers'
require 'shoulda/matchers'

ENV['AUTH_SECRET'] = 'test'
ENV['TOKEN_LIFETIME'] = '100'
ENV['MAX_CATEGORY_AMOUNT'] = '10'

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

RSpec.configure do |config|
  DatabaseCleaner[:active_record].strategy = :truncation

  config.before(:suite) do
    DatabaseCleaner[:active_record].start
  end

  config.after(:suite) do
    DatabaseCleaner[:active_record].clean
  end

  config.use_transactional_fixtures = true

  config.infer_spec_type_from_file_location!

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.filter_rails_from_backtrace!

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  # Replace fixtures with factory_bot
  config.include FactoryBot::Syntax::Methods

  config.mock_with :rspec do |mocks|
    mocks.syntax = %i[expect]
    mocks.verify_partial_doubles = true
  end

  # Run specs in random order
  config.order = :random
  Kernel.srand config.seed
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
