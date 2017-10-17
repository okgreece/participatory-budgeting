#!/bin/sh
cp -rv docker/config .
cp -rv docker/db .
rake assets:precompile
rake db:create
rake db:migrate