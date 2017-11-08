require_relative 'boot'

require 'rails'
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'action_cable/engine'
require 'carrierwave'

Bundler.require(*Rails.groups)
Dotenv::Railtie.load
HOSTNAME = ENV['HOSTNAME']

module TodolistApi
  class Application < Rails::Application
    config.load_defaults 5.1

    config.generators do |g|
      g.test_framework        :rspec
      g.fixture_replacement   :factory_girl, dir: 'spec/factories'
    end

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*',
                 headers: :any,
                 methods: %i[get post options put patch delete],
                 expose: ['access-token', 'expiry', 'token-type', 'uid', 'client'],
                 max_age: 36000
      end
    end

    config.api_only = true
  end
end
