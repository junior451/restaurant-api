FROM ruby:2.3.0
MAINTAINER Bugs Bunny <bbunny@rubyplus.com>

RUN apt-get update && \
    apt-get install -y net-tools

# Install gems
ENV APP_HOME /app
ENV HOME /root
RUN mkdir $APP_HOME
WORKDIR $APP_HOME
COPY Gemfile* $APP_HOME/
RUN bundle install

# Upload source
COPY . $APP_HOME

# Start server
ENV PORT 2000
EXPOSE 2000
CMD ["ruby", "main.rb"]