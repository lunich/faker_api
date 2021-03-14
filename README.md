# Just a dummy API

## Description

It's just a simple dummy API.

Data: [faker](https://github.com/faker-ruby/faker)

Framework: [sinatra](https://github.com/sinatra/sinatra)

Format: JSON

## Usage

```sh
# Clone the app:
git clone git@github.com:lunich/faker_api.git app
# Goto the app folder
cd app
# Install prerequirements
bundle install
# Start the server
bundle exec puma -C config/puma.rb
```

**Note:** Server is starting on port 4567 by default

## Test it

```sh
curl \
  -H 'Accept: application/json' \
  -H 'Content-type: application/json' \
  -d '{"user":{"name":"Dima Lunich","email":"dima.lunich@gmail.com"}}' \
  http://localhost:4567/api/users
```

## API

TBD
