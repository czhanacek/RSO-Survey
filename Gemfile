ruby '2.3.4'

gem 'sdoc', '~> 0.4.0', group: :doc
source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '5.0.2'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

# Use Devise for authentication
gem 'devise'

# Use Unicorn as the app server
gem 'unicorn'

# Bootstrap
gem 'bootstrap', '~> 4.0.0.alpha6'

# Font Awesome
gem "font-awesome-rails", '~> 4.7.0'

# for importing csvs
gem 'csv-importer'

# for uploading files
gem "carrierwave"

# seed dump
gem "seed_dump"
# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Handles positions of questions/answers
gem 'acts_as_list'

# Pinning minitest at this version because of a bug in Rails that causes Travis to fail.
gem "minitest", "5.10.1"

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Use sqlite3 as the database for Active Record
  gem 'sqlite3'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

group :production do
  gem "pg"
end
