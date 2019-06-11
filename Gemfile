source 'https://rubygems.org'
ruby '2.5.0'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'active_model_serializers'
gem 'bcrypt', '~> 3.1.7'
gem 'cancancan'
gem 'jwt'
gem 'kaminari'
gem 'money'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.7'
gem 'rack-cors', require: 'rack/cors'
gem 'rails', '~> 5.1.5'
gem 'rubocop'
gem 'rubocop-performance'
gem 'seed-fu', '~> 2.3', '>= 2.3.7'
gem 'smtp2go-rails'
gem 'swagger-blocks'

group :development, :test do
  gem 'actionview-encoded_mail_to'
  gem 'byebug'
  gem 'database_cleaner'
  gem 'dotenv-rails'
  gem 'selenium-webdriver'
  # use rspec
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'rspec-collection_matchers'
  gem 'rspec-rails'
  gem 'shoulda-matchers'
  # for TimeZone
  gem 'tzinfo-data'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  gem 'capistrano', '~> 3.11', require: false
  gem 'capistrano-bundler', '~> 1.5', require: false
  gem 'capistrano-rails', '~> 1.4', require: false
  gem 'capistrano-rvm', require: false
end

gem 'rails_12factor', group: :production
