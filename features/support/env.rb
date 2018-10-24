require 'simplecov'

ENV['CUCUMBER'] = 'cucumber'

# IMPORTANT: This file is generated by cucumber-rails - edit at your own peril.
# It is recommended to regenerate this file in the future when you upgrade to a
# newer version of cucumber-rails. Consider adding your own code to a new file
# instead of editing this one. Cucumber will automatically load all features/**/*.rb
# files.
require 'capybara'
require 'capybara/cucumber'
require 'cucumber/rails'
require 'cucumber/rspec/doubles'
require 'rack_session_access/capybara'
require 'factory_bot_rails'
require 'aruba/cucumber'
require 'timecop'
require 'billy/capybara/cucumber'
require 'capybara/poltergeist'

Capybara.javascript_driver = :poltergeist

Dir['../../spec/factories/*.rb'].each {|file| require_relative file }
Dir[Rails.root.join('spec/support/matchers/*.rb')].each { |file| require file  }

# https://github.com/jnicklas/capybara/commit/4f805d5a1c42da29ed32ab0371e24add2dc08af1
Capybara.add_selector(:css) do
    xpath { |css| XPath.css(css) }
end
# Capybara defaults to XPath selectors rather than Webrat's default of CSS3. In
# order to ease the transition to Capybara we set the default here. If you'd
# prefer to use XPath just remove this line and adjust any selectors in your
# steps to use the XPath syntax.
Capybara.default_selector = :css
Capybara.default_max_wait_time = 3
Capybara.asset_host = 'http://localhost:3000'
Capybara.server = :puma

Billy.configure do |c|
  c.cache = true
  c.ignore_params = ['http://maps.google.com/maps/vt',
                     'http://maps.googleapis.com/maps/gen_204',
                     'http://maps.googleapis.com/maps/api/js/AuthenticationService.Authenticate',
                     'http://csi.gstatic.com/csi',
                     'http://maps.gstatic.com/mapfiles/openhand_8_8.cur',
                     'http://www.google-analytics.com/collect',
                     'http://www.google-analytics.com/r/collect',
                     'http://www.google-analytics.com/__utm.gif',
                     'http://maps.googleapis.com/maps/api/js/ViewportInfoService.GetViewportInfo',
                     ]
  c.persist_cache = true
  c.cache_path = 'features/req_cache/'
end
Billy.proxy.reset_cache

Capybara.register_driver :poltergeist do |app|
  options = {
    js_errors: false,
    phantomjs: Phantomjs.path,
  }
  Capybara::Poltergeist::Driver.new(app, options)
end

Capybara.register_driver :pg_billy do |app|
  options = {
    js_errors: false,
    phantomjs: Phantomjs.path,
    phantomjs_options: [
      '--ignore-ssl-errors=yes',
      "--proxy=#{Billy.proxy.host}:#{Billy.proxy.port}"
    ]
  }
  Capybara::Poltergeist::Driver.new(app, options)
end

ShowMeTheCookies.register_adapter(:pg_billy, ShowMeTheCookies::Poltergeist)

Before('@billy') do
  Capybara.current_driver = :pg_billy
end

After('@billy') do
  Capybara.use_default_driver
end

Before('@javascript') do
  @javascript = true
end


# By default, any exception happening in your Rails application will bubble up
# to Cucumber so that your scenario will fail. This is a different from how
# your application behaves in the production environment, where an error page will
# be rendered instead.
#
# Sometimes we want to override this default behaviour and allow Rails to rescue
# exceptions and display an error page (just like when the app is running in production).
# Typical scenarios where you want to do this is when you test your error pages.
# There are two ways to allow Rails to rescue exceptions:
#
# 1) Tag your scenario (or feature) with @allow-rescue
#
# 2) Set the value below to true. Beware that doing this globally is not
# recommended as it will mask a lot of errors for you!
#
ActionController::Base.allow_rescue = false

# Remove/comment out the lines below if your app doesn't have a database.
# For some databases (like MongoDB and CouchDB) you may need to use :truncation instead.
begin
  DatabaseCleaner.strategy = :truncation
rescue NameError
  raise 'You need to add database_cleaner to your Gemfile (in the :test group) if you wish to use it.'
end

# You may also want to configure DatabaseCleaner to use different strategies for certain features and scenarios.
# See the DatabaseCleaner documentation for details. Example:
#
#   Before('@no-txn,@selenium,@culerity,@celerity,@javascript') do
#     # { :except => [:widgets] } may not do what you expect here
#     # as tCucumber::Rails::Database.javascript_strategy overrides
#     # this setting.
#     DatabaseCleaner.strategy = :truncation
#   end
#
#   Before('~@no-txn', '~@selenium', '~@culerity', '~@celerity', '~@javascript') do
#     DatabaseCleaner.strategy = :transaction
#   end
#

# Possible values are :truncation and :transaction
# The :transaction strategy is faster, but might give you threading problems.
# See https://github.com/cucumber/cucumber-rails/blob/master/features/choose_javascript_database_strategy.feature
Cucumber::Rails::Database.javascript_strategy = :truncation

#Around('@email') do |scenario, block|
#  ActionMailer::Base.delivery_method = :test
#  ActionMailer::Base.perform_deliveries = true
#  ActionMailer::Base.deliveries.clear
#  block.call
#end
# Aruba working directory (default: Aruba creates tmp/aruba)
Before do
  @dirs = ["#{Rails.root}"]
end

Before('@in-production') do
  Rails.env = 'production'
end

After('@in-production') do
  Rails.env = 'test'
end

def logger_with_no_output
  logger = double('Logger').as_null_object
  allow(Logger).to receive(:new).and_return(logger)
end

Before do
  logger_with_no_output
end

After('@time_travel') do
  Timecop.return
end

# To be used in conjunction with rerun option, so that we don't return a failing
# exit code until the second try fails
at_exit do
  exit 0 if ENV['NEVER_FAIL'] == 'true'
end

Capybara.asset_host = 'http://localhost:3000'
