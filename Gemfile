source 'https://rubygems.org'

gem 'hydra', '6.0.0'
gem 'bootswatch-rails'
gem 'omniauth'
gem 'omniauth-cas'

gem 'sqlite3'
gem 'httparty'

#logging
gem 'log4r', '1.1.9'

gem "unicode", :platforms => [:mri_18, :mri_19]
gem "devise"
gem "devise-guests", "~> 0.3"
gem "bootstrap-sass"
gem "therubyracer"
#gem "client_side_validations", "3.2.0"
gem 'thin'


# Rails uses asset pipeline.  You will need these gems for used your assets in development.
# However, you won't need them in production because they will be precompiled.
group :assets do
  gem 'sass-rails', '~> 3.2.3'
  gem 'uglifier'
  gem 'jquery-rails'
  gem 'less'
  gem 'less-rails' #Sprockets (what Rails 3.1 uses for its asset pipeline) supports

  gem 'coffee-rails'
  gem 'twitter-bootstrap-rails'
end

# You will probably want to use these to run the tests you write for your hydra head
# For testing with rspec
group :development, :test do
  gem 'test-unit'
  gem 'ruby-prof'
  gem 'rspec-rails'
  gem 'jettywrapper'
  gem 'spork'
  gem 'debugger'
  gem 'equivalent-xml'
  gem 'rb-inotify', '~> 0.8.8', :require => false
  gem 'factory_girl_rails', '~> 4.1'
  gem 'guard-spork'
  gem 'selenium-webdriver'
  gem 'cucumber-rails', :require => false
  gem 'database_cleaner'
  gem 'capybara-webkit'
end

group :development do
  gem "better_errors"
  gem "binding_of_caller"
end

