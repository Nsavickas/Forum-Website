source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.8' #'4.2.1', '4.2.4'
gem 'bcrypt', '3.1.11'
gem 'faker', '1.4.2'
gem 'carrierwave', '0.10.0'
gem 'mini_magick', '3.8.0'
gem 'fog', '1.23.0'
gem 'kaminari'
gem 'html5_validators'
gem 'sidekiq'
gem 'sinatra', '>= 1.3.0', require: nil
gem 'xmlrpc'

#gem 'thinking-sphinx', '~> 3.1.4'
#gem 'decent_exposure'
#gem 'responders'
#gem 'impressionist'
#gem 'sunspot_rails', :git => 'https://github.com/sunspot/sunspot.git', :ref => '79175ea'
#gem 'websocket-rails'

# Use mysql as the database for Active Record
gem 'mysql2', '0.4.5'

gem 'json', github: 'flori/json', branch: 'v1.8'
# Use SCSS for stylesheets
gem 'bootstrap-sass', '~> 3.2.0'
gem 'autoprefixer-rails'
gem 'sass-rails', '~> 5.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby
gem 'paperclip'
gem 'omniauth'
gem 'omniauth-twitter'
gem 'omniauth-facebook'

# Use jquery as the JavaScript library
gem 'jquery-rails', '2.3.0'
gem 'jquery-ui-rails'
gem 'jquery-turbolinks'
gem 'fancybox-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'
group :development do
  #gem 'sunspot_solr'
  #gem 'sunspot_solr', :git => 'https://github.com/sunspot/sunspot', :ref => 'ada19e5'
  gem 'progress_bar'
  #gem 'haml-rails', '>= 0.9.0'
end


group :test do
  gem 'minitest-reporters', '1.0.5'
  gem 'mini_backtrace',     '0.1.3'
  #gem 'guard-minitest',     '2.3.1'
  gem 'guard-rspec', require: false
end

group :production do
  #gem 'pg',             '0.17.1'
  gem 'rails_12factor', '0.0.2'
end

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'rspec-rails'
  gem 'capybara'
  gem 'selenium-webdriver'
  #gem 'poltergeist'
  gem 'email_spec'
  gem 'factory_girl_rails'
  gem 'shoulda-matchers'
  gem 'cucumber-rails', require: false
  gem 'database_cleaner'
  gem 'letter_opener'
  gem 'rack_session_access'
  gem 'simplecov', require: false

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
