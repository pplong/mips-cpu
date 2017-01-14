#!/bin/sh
export LC_ALL=C
export LC_CTYPE=C
export LANG=C
exec sed -e 's/^(\*NOMINCAML \(.*\)\*)$/\1/' -e 's/^(\*MINCAML\*)\(.*\)$//' "$@"
