FROM ruby:3.3.4-slim

RUN apt-get update -qq \
      && apt-get install -y --no-install-recommends \
        git \
        libjemalloc2 \
        build-essential \
        nodejs \
        postgresql-client \
        libpq-dev \
      && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN gem install bundler:2.5.11
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git

COPY . .

EXPOSE 3000

CMD ["bundle", "exec", "rails", "server"]
