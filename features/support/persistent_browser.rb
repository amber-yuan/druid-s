require 'selenium/webdriver/remote/http/default'

module Druid
  module PersistantBrowser
    @@driver = false
    def self.get_browser
      if !@@driver
        target = ENV['BROWSER'] || 'local_chrome'

        if is_remote?(target)
          require File.dirname(__FILE__) + "/targets/#{target}"
          extend Target
        end

        @@driver = watir_browser(target) if ENV['DRIVER'] == 'WATIR'
      end
      @@driver
    end

    def self.quit
      @@driver.quit
    end

    private

    def self.is_remote?(target)
      not target.include? 'local'
    end

    def self.watir_browser(target)
      if is_remote?(target)
        Watir::Browser.new(:remote,
                           :http_client => client,
                           :url => url,
                           :desired_capabilities => desired_capabilities )
      else
        browser = target.gsub('local_', '').to_sym
        Watir::Browser.new browser, :http_client => client
      end
    end

    def self.client
      Selenium::WebDriver::Remote::Http::Default.new
    end

    def self.capabilities(browser, version, platform, name)
      caps = Selenium::WebDriver::Remote::Capabilities.send browser
      caps.version = version
      caps.platform = platform
      caps[:name] = name
      caps
    end

    def self.url
      "http://pageobject:18002ee8-963b-472e-9425-2baf0a2b6d95@ondemand.saucelabs.com:80/wd/hub"
    end
  end
end
