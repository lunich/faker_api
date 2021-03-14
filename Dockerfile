FROM ruby:3.0-slim-buster

RUN set -eux; \
        apt-get update; \
        apt-get install -y --no-install-recommends \
                make \
                gcc \
        ; \
        rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY Gemfile* .

RUN bundle config set --local system 'true'

RUN bundle config build.ffi --enable-system-libffi

RUN bundle install

COPY . .

EXPOSE 9292

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
