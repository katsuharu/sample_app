require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SampleApp
  class Application < Rails::Application

  	config.time_zone = 'Tokyo'
  	config.active_record.default_timezone = :local
  	config.i18n.default_locale = :ja
  	config.generators do |g|
		g.javascripts false
		g.stylesheets false
		g.helper false
		g.test_framework false
	end
  end
end