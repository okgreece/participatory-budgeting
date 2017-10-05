FROM ruby:2.4.1-jessie

VOLUME /var/lib/postgresql/data

#install requirements
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get install -y nodejs postgresql-9.4 postgresql-contrib postgresql-client nano --no-install-recommends

RUN gem install passenger && \
    apt-get install -y libcurl4-openssl-dev && \
    passenger-install-nginx-module --auto

ADD docker/nginx.conf /opt/nginx/conf/nginx.conf

RUN echo "daemon off;" >> /opt/nginx/conf/nginx.conf

RUN bundle config --global frozen 1

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app/
ADD Gemfile /usr/src/app/
ADD Gemfile.lock /usr/src/app/
RUN bundle install --system

USER postgres
RUN    /etc/init.d/postgresql start &&\
       psql --command "CREATE USER root WITH SUPERUSER PASSWORD 'root';"

USER root
ADD . /usr/src/app
RUN npm install --unsafe-perm

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
