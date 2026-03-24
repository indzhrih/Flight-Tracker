# frozen_string_literal: true

source 'https://rubygems.org'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 7.2.2', '>= 7.2.2.1'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'
# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '>= 5.0'
# Build JSON APIs with ease [https://github.com/rails/jbuilder]
# gem "jbuilder"
# Use Redis adapter to run Action Cable in production
# gem "redis", ">= 4.0.1"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[windows jruby]

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin Ajax possible
# gem "rack-cors"

# [https://github.com/lostisland/faraday]
gem 'faraday'
gem 'faraday-follow_redirects'
gem 'faraday-net_http'

group :development, :test do
  # [https://github.com/bkeepers/dotenv]
  gem 'dotenv-rails'

  # [https://github.com/rspec/rspec-rails/tree/6-1-maintenance]
  gem 'rspec-rails', '~> 6.1.0'

  # [https://rubygems.org/gems/factory_bot_rails]
  gem 'factory_bot_rails', '~> 6.4', '>= 6.4.3'

  # [https://rubygems.org/gems/faker/versions/3.4.2]
  gem 'faker', '~> 3.4', '>= 3.4.2'

  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[mri windows], require: 'debug/prelude'

  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem 'brakeman', require: false

  # rubocop [https://github.com/rubocop/rubocop]
  gem 'rubocop', require: false
  gem 'rubocop-capybara', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rails-omakase', require: false
  gem 'rubocop-rspec', require: false
end

group :test do
  # [https://rubygems.org/gems/database_cleaner/versions/2.0.2]
  gem 'database_cleaner', '~> 2.0', '>= 2.0.2'

  # [https://github.com/thoughtbot/shoulda-matchers]
  gem 'shoulda-matchers', '~> 6.0'

  # [https://rubygems.org/gems/simplecov]
  gem 'simplecov', '~> 0.22.0'

  # [https://github.com/rails/rails-controller-testing]
  gem 'rails-controller-testing'
end
