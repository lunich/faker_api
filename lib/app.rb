#!/usr/bin/env ruby
# frozen_string_literal: true
Bundler.require
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
def generate_users(count:)
  count.times.map do |i|
    user(id: i + 1)
  end
end
def users_response(count: 15, page: 1, per_page: 5)
  users = generate_users(count: count)
  offset = per_page * (page - 1)
  {
    result: users[offset, per_page] || [],
    count: count,
    per_page: per_page
  }
end
before do
  # Setup random config
  Faker::Config.random = Random.new(42)
  # Make it possible to be used from any hostname
  headers['Access-Control-Allow-Origin'] = '*'
end
get '/' do
  json name: 'Faker API',
       version: '0.0.1',
       description: 'API for my cat to learn'
end
get '/api/users' do
  page = (params[:page] || '1').to_i
  per_page = (params[:per_page] || '5').to_i
  count = (params[:count] || '15').to_i
  response = users_response(count: count, page: page, per_page: per_page)
  json(response)
end
