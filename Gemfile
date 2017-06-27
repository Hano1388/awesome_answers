# This file 'Gemfile' is used by the 'Bundler' gem to manage the gems that are needed
# for our Rails projects. We specify all the gems we need in here with the
# proper version and Bundler will automatically 'require' those gems for us.
# Bundler will auto-generate and will update a file called 'Gemfile.lock' which
# will specify the exam version of every gem that is being used. As you note below
# some Gems don't specify exact versions, however, when you run 'bundle install'
# bundler will lock the version to the latest current version installed on your
# system or it will install the latest from rubygems.org
source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby '2.4.1'
gem 'cancancan', '~> 2.0'

gem 'delayed_job_active_record'
gem "delayed_job_web"
gem 'active_model_serializers'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.1'
gem "font-awesome-rails"

gem 'simple_form'

gem 'carrierwave', '~> 1.0'

gem 'mini_magick'

gem 'fog'

gem 'jquery-rails'
gem 'chosen-rails'
gem 'rack-cors'

# Use postgresql as the database for Active Record
gem 'pg', '~> 0.18'
# Use Puma as the app server
gem 'puma', '~> 3.7'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
gem 'rails-erd'

gem 'bootstrap-sass', '~> 3.3', '>= 3.3.7'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

gem 'faker', github: 'stympy/faker'
gem 'cowsay'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'interactive_editor'
  gem 'awesome_print'
  gem "letter_opener"
  # the hirb gem gives the nice§ view in rails c to tables
  gem 'hirb'
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
