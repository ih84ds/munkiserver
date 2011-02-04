require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Auto-require default libraries and those for the current Rails environment.
Bundler.require :default, Rails.env

module Munki
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
      
    # Load server configuration YAML file
    settings = nil
    begin
      settings = YAML.load(File.read("#{Rails.root}/config/settings.yaml"))
    rescue Errno::ENOENT
      # config/settings.yaml doesn't exist
    end
    
    # Add additional load paths for your own custom dirs
    # config.load_paths += %W( #{config.root}/extras )
    config.autoload_paths += %W(
        #{Rails.root}/app/models/join_models
        #{Rails.root}/app/models/magic_mixin
        #{Rails.root}/app/models/manifest
        #{Rails.root}/app/models/service
      )

    # Add custom mime types
    Mime::Type.register "text/plist", :plist
    
    # Where we store the packages
    PACKAGE_DIR = Rails.root + "packages"
    # Make sure the dir exists
    FileUtils.mkdir_p(PACKAGE_DIR)
    # Command line utilities
    MAKEPKGINFO = Pathname.new("/usr/local/munki/makepkginfo")

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
    # config.i18n.default_locale = :de

    # Configure generators values. Many other options are available, be sure to check the documentation.
    # config.generators do |g|
    #   g.orm             :active_record
    #   g.template_engine :erb
    #   g.test_framework  :test_unit, :fixture => true
    # end
    
    # A secret is required to generate an integrity hash for cookie session data
    config.secret_token = "d24c49a98769afee486d236d82820f20fa0cd219581c024232d615c9f64eafa1e72dc07bd91f070cbb3c61ecb82e276d986ca42397d7cf08b98ef3139ca970c2"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters << :password
    
    if settings.present?
      config.action_mailer.delivery_method = settings[:action_mailer][:delivery_method]
      config.action_mailer.sendmail_settings = settings[:action_mailer][:sendmail_settings] if settings[:action_mailer][:delivery_method] == :sendmail
      config.action_mailer.smtp_settings = settings[:action_mailer][:smtp_settings] if settings[:action_mailer][:delivery_method] == :smtp
      config.action_mailer.raise_delivery_errors = true
    end
  end
end