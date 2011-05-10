#!/bin/sh
exec /usr/local/rvm/bin/rvm-shell '1.9.2' -c "gem $*"
