#!/bin/bash
nginx -g "daemon off;" &
/opt/nginx_shell/auto-reload.sh
