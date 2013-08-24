source 'https://rubygems.org'

gem 'rails', '3.2.14'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'pg'


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

gem 'therubyracer'

group :deployment do
  gem 'capistrano'
  gem 'capistrano-ext'
  gem 'capistrano_colors'
  gem 'rvm-capistrano'
end

group :development, :test do
  gem 'pry'
  gem 'pry-rails'
  gem 'pry-nav'
  gem 'meta_request'
end

gem 'bcrypt-ruby'

gem 'newrelic_rpm'

group :development, :test do
  gem 'rspec-rails', '>= 2.6.0'
  gem 'launchy'
  gem 'spork-rails'
  gem 'factory_girl_rails', '~> 4.0'
  gem 'database_cleaner'
end

gem 'capybara'
gem 'capybara-webkit'
group :production do
  gem 'headless'
end

gem 'rmagick', :require => 'RMagick'

gem 'memcached'