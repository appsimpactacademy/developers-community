# spec/support/capybara_select_option.rb

module CapybaraSelectOption
  def select_option(locator, option_text)
    find("##{locator}").find(:option, option_text).select_option
  end
end

RSpec.configure do |config|
  config.include CapybaraSelectOption, type: :feature
end
