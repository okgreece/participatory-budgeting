#!/bin/bash
export SECRET_KEY_BASE=$(rake secret)
sh docker/initialize.sh
/opt/nginx/sbin/nginx
