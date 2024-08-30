# frozen_string_literal: true

require 'http'
require 'roda'
require 'tilt'
require_relative 'lib/db'

class App < Roda
  Job = DB[:jobs]
  public_constant :Job

  plugin :assets, css: 'tailwind.css'
  plugin :head
  plugin :public, root: 'assets'
  plugin :render
  plugin :slash_path_empty
  plugin :partials, views: 'views'

  GEOS = [
    'Alabama',
    'Alaska',
    'Arizona',
    'Arkansas',
    'California',
    'Colorado',
    'Connecticut',
    'Delaware',
    'Florida',
    'Georgia',
    'Hawaii',
    'Idaho',
    'Illinois',
    'Indiana',
    'Iowa',
    'Kansas',
    'Kentucky',
    'Louisiana',
    'Maine',
    'Maryland',
    'Massachusetts',
    'Michigan',
    'Minnesota',
    'Mississippi',
    'Missouri',
    'Montana',
    'Nebraska',
    'Nevada',
    'New Hampshire',
    'New Jersey',
    'New Mexico',
    'New York',
    'North Carolina',
    'North Dakota',
    'Ohio',
    'Oklahoma',
    'Oregon',
    'Pennsylvania',
    'Rhode Island',
    'South Carolina',
    'South Dakota',
    'Tennessee',
    'Texas',
    'Utah',
    'Vermont',
    'Virginia',
    'Washington',
    'West Virginia',
    'Wisconsin',
    'Wyoming',
    'Puerto Rico',
    'Guam',
    'Virgin Islands'
  ].freeze
  public_constant :GEOS

  route do |r|
    r.assets
    r.public

    r.root do
      @geos = GEOS
      view 'home'
    end

    r.post 'search' do
      occ_title = r.params['job-title'].to_s.strip
      area_title = r.params['state'].to_s.strip
      @jobs =
        if occ_title.empty?
          []
        else
          Job.select(:area_title, :prim_state, :occ_code, :occ_title, :tot_emp)
             .where(area_title:)
             .where(Sequel.ilike(:occ_title, "%#{occ_title}%"))
             .order(Sequel.desc(Sequel.lit("CAST(REPLACE(TOT_EMP, ',', '') AS INTEGER)")))
             .limit(100)
             .all
        end
      partial 'results'
    end

    r.on 'jobs' do
      r.get true do
        @jobs = Job.limit(50)
        view 'index'
      end

      r.on String, String do |prim_state, occ_code|
        @job = Job.where(OCC_CODE: occ_code, PRIM_STATE: prim_state).first
        view 'show'
      end
    end
  end
end
