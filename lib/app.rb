#!/usr/bin/env ruby
# frozen_string_literal: true

require 'sinatra'
require 'sinatra/json'
require 'faker'

def user(id:)
  {
    id: id,
    followed: Faker::Boolean.boolean,
    name: Faker::Name.name,
    img: nil,
    status: Faker::Lorem.words(number: 3..6).join(' '),
    location: {
      city: Faker::Address.city,
      country: Faker::Address.country
    }
  }
end

def users(count:)
  count.times.map do |i|
    user(id: i + 1)
  end
end

def users_response(count: 15, page: 1, per_page: 5)
  users = users(count: 15)
  offset = per_page * (page - 1)
  {
    result: users[offset, per_page],
    count: count,
    per_page: per_page
  }
end

get '/' do
  json name: 'Faker API', version: '0.0.1', description: 'API for my cat to learn'
end

get '/api/users' do
  # Setup random config
  Faker::Config.random = Random.new(42)
  headers['Access-Control-Allow-Origin'] = '*'

  json users_response(page: (params[:page] || '1').to_i)
end
