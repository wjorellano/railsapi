# escape=\

FROM ruby:3.1

RUN apt-get update -yqq

COPY . /usr/src/app/

WORKDIR /usr/src/app/

RUN bundle install

CMD [ "rails", "s", "-b", "0.0.0.0"]