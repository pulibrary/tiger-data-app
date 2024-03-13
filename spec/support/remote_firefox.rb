# frozen_string_literal: true
# Add this to your rails_helper.rb or import it as a support file

Capybara.register_driver :remote_selenium do |app|
  # Pass our arguments to run headless
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument("--headless")
  options.add_argument("--no-sandbox")
  options.add_argument("--disable-dev-shm-usage")
  options.add_argument("--window-size=1400,1400")

  # and point capybara at our chromium docker container
  Capybara::Selenium::Driver.new(
    app,
    browser: :remote,
    url: "http://chrome:4444/wd/hub",
    options: options
  )
end

if ENV["CI"]

  # The IP address of the docker container running the application
  Capybara.app_host = "http://192.168.10.63:3010"

  # Set the host and port
  Capybara.server_host = "0.0.0.0"
  Capybara.server_port = "3010"

  # Add a configuration to connect to Chrome remotely through Selenium Grid

  # set the capybara driver configs
  Capybara.javascript_driver = :remote_selenium
  Capybara.default_driver = :remote_selenium

  # This will force capybara to inclue the port in requests
  Capybara.always_include_port = true
end
