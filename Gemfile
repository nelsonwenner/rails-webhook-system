source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.0"

# We list this gem first and require it via "rails-now" so as to load all environment variables immediattely, even
# before Rails or any other gems are loaded. This way any gem that needs access to environment variables can do so
# as soon as it needs them. More info: https://github.com/bkeepers/dotenv#note-on-load-order
gem "dotenv-rails", require: "dotenv/rails-now", groups: [:development, :test]

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.0.3"

# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 5.0"

# Background processing
gem "sidekiq", "~> 6.4.2"

# Queue processing
gem "redis", "~> 4.6.0"

# An easy-to-use client library for making requests
gem 'http', "5.0.0"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
# gem "jbuilder"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem "rack-cors"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[mri mingw x64_mingw]

  # Use RSpec for testing Ruby code
  gem "rspec-rails", "~> 5.0"

  # Ruby style guide, linter, and formatter. An opinionated wrapper around Rubocop.
  gem "standard", require: false

  # Reek is a tool that examines Ruby classes, modules and methods and reports any Code Smells it finds.
  gem "reek", require: false

  # Flay analyzes code for structural similarities. Differences in literal values, variable, class, method names,
  # whitespace, programming style, braces vs do/end, etc are all ignored.
  gem "flay", require: false

  # Pronto runs analysis quickly by checking only the relevant code changes.
  gem "pronto", "~> 0.11"
  gem "pronto-reek", "~> 0.11", require: false
  gem "pronto-standardrb", "~> 0.1", require: false
  gem "pronto-flay", "~> 0.11", require: false
end

group :development do
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  gem "spring"

  # Guard automates various tasks by running custom rules whenever file or directories are modified. [https://github.com/guard/guard]
  gem "guard", "~> 2.18", require: false

  # Guard::RSpec automatically run your specs (much like autotest). [https://github.com/guard/guard-rspec]
  gem "guard-rspec", "~> 4.7", require: false
end

group :test do
  # Simple one-liner tests for common Rails functionality [https://matchers.shoulda.io/]
  gem "shoulda-matchers", "~> 5.0"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]
