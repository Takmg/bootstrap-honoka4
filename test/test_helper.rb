# Configure Rails Environment
ENV['RAILS_ENV'] = 'test'

# require environment
require_relative 'dummy/config/environment'
require 'rails/test_help'

# require minitest capybara
require 'minitest/autorun'
require 'minitest/reporters'
require 'capybara/rails'
require 'capybara/minitest'
require 'capybara/dsl'
require 'webdrivers'

# settings
Webdrivers.cache_time = 10000
ROOT_PATH = File.expand_path('../', File.dirname(__FILE__))

# support directory files require
Dir['test/support/**/*.rb'].each do |file|
  file = file[4..-4]
  require_relative File.join('.', file)
end

# -----------------------------------------------------------------------------

# https://groups.google.com/forum/#!topic/chromedriver-users/ZBEju24L5ww
 
# Settings Selenium Timeout 
client = Selenium::WebDriver::Remote::Http::Default.new
client.read_timeout = 1000 # 1000 second read wait

# Capybara driver settings
Capybara.register_driver :selenium_chrome_headless do |app|
  Capybara::Selenium::Driver.load_selenium
  browser_options = ::Selenium::WebDriver::Chrome::Options.new.tap do |opts|    
    opts.args << 'start-maximized'
    opts.args << 'enable-automation'
    opts.args << '--window-size=992,768'
    opts.args << '--headless'
    opts.args << '--disable-gpu'
    opts.args << '--no-sandbox'
    opts.args << '--disable-infobars'
    opts.args << '--disable-dev-shm-usage'
    opts.args << '--disable-browser-side-navigation'
    opts.args << '--disable-site-isolation-trials'
  end
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: browser_options, http_client: client)
end

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, window_size: [1280, 768],  js_errors: false)
end

# Capybara settings
Capybara.configure do |config|
  config.server_port        = 3000
  config.app_host           = "http://localhost:#{config.server_port}"
  config.default_driver     = :selenium_chrome_headless
  config.javascript_driver  = :selenium_chrome_headless
  config.server             = :webrick
end
