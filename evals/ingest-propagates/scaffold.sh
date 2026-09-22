#!/bin/sh
# Copy this case's fixture vault into the run workspace.
set -e
cp -R "$(dirname "$0")/vault" ./vault
