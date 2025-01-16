#! /bin/sh

run-parts /opt/init-wrapper/pre-init.d
exec "$@"
