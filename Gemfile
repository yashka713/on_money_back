source 'https://rubygems.org'
ruby '2.5.0'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'active_model_serializers'
gem 'bcrypt', '~> 3.1.7'
gem 'jwt'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.7'
gem 'rack-cors', require: 'rack/cors'
gem 'rails', '~> 5.1.5'
gem 'rubocop'


group :development, :test do
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
end

gem 'rails_12factor', group: :production
