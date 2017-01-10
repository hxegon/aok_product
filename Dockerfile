FROM ruby:2.4.0-alpine

WORKDIR /app

COPY Gemfile* ./

RUN apk update && \
    apk add --no-cache --virtual build-deps ruby-dev build-base && \
    gem install bundler --no-ri --no-rdoc && \
    bundle install --without development test && \
    apk del build-deps

COPY . .

RUN mkdir processing_inbox

ENTRYPOINT /usr/local/bundle/bin/bundle exec kiba bin/upload_file.etl
# CMD [ "/bin/ash" ] # DEBUG # ash is the alpine linux shell