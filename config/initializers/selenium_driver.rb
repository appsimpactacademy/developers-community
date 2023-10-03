# config/initializers/selenium_driver.rb

require 'selenium-webdriver'

# Specify the path to the ChromeDriver executable
chrome_driver_path = ENV['CHROMDRIVER_PATH']

# Configure the Selenium WebDriver to use ChromeDriver with the specified path
Selenium::WebDriver::Chrome::Service.driver_path = chrome_driver_path

# Configure any additional options if needed
options = Selenium::WebDriver::Chrome::Options.new
options.add_argument('--headless') # Add headless option if desired

# Create the WebDriver instance
$driver = Selenium::WebDriver.for :chrome, options: options
