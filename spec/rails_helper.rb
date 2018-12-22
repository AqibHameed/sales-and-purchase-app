ENV["RAILS_ENV"] ||= 'test'
require_relative 'spec_helper'
require File.expand_path("../../config/environment", __FILE__)
require 'simplecov'
SimpleCov.start 'rails' do
  add_group 'API Controllers', 'app/controllers/api'
end
# end simpleconv configuration
require 'rspec/rails'
# require 'capybara/poltergeist'
# require 'rspec/autorun' unless defined? Zeus
# require 'database_cleaner'
require 'shoulda/matchers'
require 'devise'
include ActionView::Helpers::NumberHelper

# Capybara.register_driver :poltergeist do |app|
#   Capybara::Poltergeist::Driver.new(app, {
#       # js_errors: false,
#       js_errors: true, #setting this to true outputs all my console.logs to Terminal
#       phantomjs_options: ['--ignore-ssl-errors=yes', '--ssl-protocol=any'],
#       debug: false,
#       timeout: 500,
#       phantomjs: File.absolute_path(Phantomjs.path)
#   })
# end
# Capybara.javascript_driver = :poltergeist
# Capybara.default_driver = :poltergeist

Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end

Capybara.register_driver :headless_chrome do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
      chromeOptions: { args: %w(headless disable-gpu) }
  )

  Capybara::Selenium::Driver.new app,
                                 browser: :chrome,
                                 desired_capabilities: capabilities
end

Capybara.javascript_driver = :headless_chrome



# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!  if defined?(ActiveRecord::Migration)

RSpec.configure do |config|
  # Use :webkit for headless tests and :selenium for everything else

  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.color = true
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  config.use_transactional_fixtures = true

  config.include WaitingRspecMatchers
  config.infer_spec_type_from_file_location!

  config.before :suite do
    # DatabaseCleaner.strategy = :transaction
    # DatabaseCleaner.clean_with :truncation
  end

  config.around do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

  config.before :each do
    # DatabaseCleaner.start
  end

  config.after :each do
    # DatabaseCleaner.clean
  end

  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Devise::Test::ControllerHelpers, type: :view

  config.include FactoryBot::Syntax::Methods

  config.include Warden::Test::Helpers

  config.include(Shoulda::Callback::Matchers::ActiveModel)
  config.include(ControllerMacros, :type => :controller)

end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end