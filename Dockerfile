FROM ruby:2.4.1-jessie

#install requirements
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get install -y nodejs nano --no-install-recommends

RUN gem install passenger -v 5.1.11 && \
    apt-get install -y libcurl4-openssl-dev && \
    passenger-install-nginx-module --auto

RUN bundle config --global frozen 1

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app/
ADD Gemfile /usr/src/app/
ADD Gemfile.lock /usr/src/app/
RUN bundle install --system

ADD . /usr/src/app
RUN npm install --unsafe-perm

ADD docker/nginx.conf /opt/nginx/conf/nginx.conf

RUN echo "daemon off;" >> /opt/nginx/conf/nginx.conf

# Initialize log
RUN cat /dev/null > /usr/src/app/log/production.log
RUN chmod -R a+w /usr/src/app/log
RUN chmod -R 777 /usr/src/app/public

EXPOSE 80

ENV RAILS_ENV=production
ENV NODE_ENV=production
ADD docker/start.sh /usr/src/app/
RUN chmod +x /usr/src/app/start.sh
CMD ["./start.sh"]
