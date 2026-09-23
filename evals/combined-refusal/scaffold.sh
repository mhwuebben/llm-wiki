#!/bin/sh
# Two wikis side by side: this case's fixture vault, copied twice under two vault ids.
set -e
cp -R "$(dirname "$0")/vault" ./research
cp -R "$(dirname "$0")/vault" ./personal
sed 's/wiki-ev0001/wiki-ev0002/' ./personal/_meta/schema.md > ./personal/_meta/schema.tmp
mv ./personal/_meta/schema.tmp ./personal/_meta/schema.md
