# frozen_string_literal: true

require 'sequel'

DB = Sequel.connect('sqlite://db/salaries.db')
