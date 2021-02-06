#!/bin/bash

set -euo pipefail

rm -rf ./public
zola build
scp -r ./public/* ./public/.well-known thejpster@yali.mythic-beasts.com:www/www.thejpster.org.uk/

