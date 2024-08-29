# frozen_string_literal: true

require 'http'
require 'rack'
require 'roda'
require 'tilt'
require_relative 'lib/db'

class App < Roda
  Job = DB[:jobs]

  plugin :assets, css: 'tailwind.css'
  plugin :head
  plugin :public, root: 'assets'
  plugin :render
  plugin :slash_path_empty

  route do |r|
    r.assets
    r.public

    r.root do
      view 'home'
    end

    r.post do
      @query = r.params['search']
      r.redirect "jobs/#{@query}"
    end

    r.on 'jobs' do
      r.get true do
        @jobs = Job.limit(50)
        view 'index'
      end

      r.on String do |id|
        @job = Job.where(OCC_CODE: id).first
        view 'show'
      end
    end
  end
end

run App.freeze.app
