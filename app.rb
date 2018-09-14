#!/usr/bin/env ruby

require "rubygems"
require 'json'
require 'open-uri'
require 'tilt/erb'
require 'sinatra'

# can add another tab of the spreadsheet for testing
# RELEASE_URL = n/a

# upcoming release list
RELEASE_URL = 'https://docs.google.com/spreadsheets/u/0/d/1JbQg9tG4hqq0lrCu9gP6DZY_ZgI5XwsHnqIzk6xI30M/export?format=tsv&id=1JbQg9tG4hqq0lrCu9gP6DZY_ZgI5XwsHnqIzk6xI30M&gid=0'
RELEASE_FIELDS =  [:project, :release_date]
DEFAULT_VALS = ["puppetlabs", "12-08-1994"]

set :port, 8334
set :bind, '0.0.0.0'
set :erb, :trim => '-'
set :static, true
set :public_folder, Proc.new { File.join(File.dirname(__FILE__), 'public')  }

get '/' do
  @release = release_on_deck(session)
  erb :index
end

get '/api/v1/release' do
  content_type :json
  release_on_deck(session).to_json
end

def validate(default,input)
  if input.nil? or input.empty?
    default
  else
    input
  end
end

def parse_sheet(session,url)
  rows = open(url).each_line

  rows.drop(1).map do |row|
    row.force_encoding('UTF-8')
    values = row.split("\t").map(&:strip)
    v = []
    # :project, :release_date
    DEFAULT_VALS.zip(values).each do |default,value|
      v << validate(default,value)
    end
    v[4].gsub!('%','')     # strip % to avoid confusing erb
    Hash[RELEASE_FIELDS.zip(v)]
  end
end

def release_on_deck(session)
  parse_sheet(session,RELEASE_URL)
end
