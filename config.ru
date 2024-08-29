# frozen_string_literal: true

require 'http'
require 'rack'
require 'roda'
require 'tilt'

class App < Roda
  plugin :render

  route do |r|
    r.get('home') do
      render('home')
    end
  end
end

run App.freeze.app
