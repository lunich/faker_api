#!/usr/bin/env ruby
# frozen_string_literal: true
Bundler.require

DEFAULT_USERS = 15

def user(id:)
  images = %w[cat fox bear dog]
  img = "/img/#{images.sample(random: $RANDOM)}.jpg"
  name = Faker::Name.name
  {
    id: id,
    followed: Faker::Boolean.boolean,
    name: name,
    img: img,
    status: Faker::Lorem.words(number: 3..6).join(' '),
    location: {
      city: Faker::Address.city,
      country: Faker::Address.country
    },
    description: Faker::Lorem.paragraph,
    contacts: {
      facebook: Faker::Internet.username(specifier: name),
      twitter: Faker::Internet.username(specifier: name),
      instagram: Faker::Internet.username(specifier: name),
      email: Faker::Internet.free_email(name: name)
    },
    profession: Faker::IndustrySegments.sector
  }
end

def generate_users(count:)
  count.times.map do |i|
    user(id: i + 1)
  end
end

def user_response(id:)
  users = generate_users(count: [DEFAULT_USERS, id].max)
  {
    result: users[id - 1]
  }
end

def users_response(count: 15, page: 1, per_page: 5)
  users = generate_users(count: count)
  offset = per_page * (page - 1)
  result = users[offset, per_page] || []
  {
    result: result.map { |u| u.slice(:id, :followed, :name, :img, :status, :location) },
    count: count,
    per_page: per_page
  }
end

before do
  # Setup random config
  $RANDOM = Random.new(42)
  Faker::Config.random = $RANDOM
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
  count = (params[:count] || DEFAULT_USERS).to_i

  response = users_response(count: count, page: page, per_page: per_page)

  json response
end

get '/api/users/:id' do
  json user_response(id: params[:id].to_i)
end
