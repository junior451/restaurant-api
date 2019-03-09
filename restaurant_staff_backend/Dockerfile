FROM ruby:2.3.0

RUN apt-get update && \
  apt-get install -y net-tools

# Install gems
ENV APP_HOME /app
ENV HOME /root
RUN mkdir /usr/src/app/
WORKDIR /usr/src/app/
COPY Gemfile* /usr/src/app/
RUN bundle install

# Upload source
COPY . /usr/src/app/

# Start server
EXPOSE 5000
CMD ["rackup", "--host", "0.0.0.0", "-p", "5000"]