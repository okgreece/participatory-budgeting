#!/bin/sh
cp -rv docker/config .
cp -rv docker/db .
cp -rv docker/branding/stylesheets app/assets
cp -rv docker/branding/images/* public/img
cp -rv docker/branding/views/* app/views
rake assets:precompile
rake db:create
rake db:migrate