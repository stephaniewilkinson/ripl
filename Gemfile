# frozen_string_literal: true

source 'https://rubygems.org'

ruby File.read(File.join(__dir__, '.ruby-version')).chomp.delete_prefix('ruby-')

gem 'http'
gem 'rackup'
gem 'roda'
gem 'sequel'
gem 'sqlite3'

group :development do
  gem 'rubocop'
  gem 'rubocop-performance'
  gem 'rubocop-sequel'
end
