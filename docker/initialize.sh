#!/bin/sh
cp -rv docker/config .
cp -rv docker/db .
rake assets:precompile
service postgresql start
rake db:create
rake db:migrate
rake db:seed
