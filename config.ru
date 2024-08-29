# frozen_string_literal: true

require 'http'
require 'rack'
require 'roda'
require 'tilt'
require_relative 'lib/db'

class App < Roda
  JOBS = DB[:jobs]
  plugin :render

  route do |r|
    r.root do
      render('home')
    end

    r.on('index') do
      render('index')
    end
  end
end

run App.freeze.app
