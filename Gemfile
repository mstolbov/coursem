source "https://rubygems.org"

gem "rails", "~> 7.2.1"
gem 'pg', '~> 1.5'
gem 'puma', '~> 6.4', '>= 6.4.2'
gem 'ransack', '~> 4.2', '>= 4.2.1'
gem 'kaminari', '~> 1.2', '>= 1.2.2'
gem 'active_model_serializers', '~> 0.10.14'
gem 'dry-rails', '~> 0.7.0'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin Ajax possible
# gem "rack-cors"

gem 'rswag-api', '~> 2.14'
gem 'rswag-ui', '~> 2.14'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"

  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "brakeman", require: false

  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  gem "rubocop-rails-omakase", require: false

  gem 'factory_bot_rails', '~> 6.4', '>= 6.4.3'

  gem 'rspec', '~> 3.13'
  gem 'rspec-rails', '~> 6.1', '>= 6.1.4'
  gem 'faker', '~> 3.4', '>= 3.4.2'

  gem 'rswag-specs', '~> 2.14'

  gem 'simplecov', '~> 0.22.0', require: false
end
